# =============================================================================
# LAB 02 - AZURE TRAFFIC MANAGER
# =============================================================================
#
# Purpose:
# Rebuild the Traffic Manager architecture that we first created manually
# with Azure CLI.
#
# Architecture:
#
#                       Azure Traffic Manager
#                        tm-az700-global
#                              |
#                    Geographic DNS routing
#                              |
#             +----------------+----------------+
#             |                |                |
#          GEO-NA           GEO-EU       GEO-AS + GEO-AP
#             |                |                |
#          ep-eus           ep-weu           ep-sea
#             |                |                |
#          East US        West Europe     Southeast Asia
#             |                |                |
#            ACI              ACI              ACI
#
#
# IMPORTANT MENTAL MODEL:
#
# Traffic Manager is NOT in the application data path.
#
# Client
#   |
#   v
# DNS Resolver
#   |
#   v
# Traffic Manager
#   |
#   | returns DNS answer
#   v
# Client ----------------------------------> Regional ACI endpoint
#
# Traffic Manager performs DNS steering.
# The client then connects DIRECTLY to the selected regional endpoint.
#
# =============================================================================


# =============================================================================
# SECTION 1 - REGIONAL ENDPOINT DATA MODEL
# =============================================================================
#
# Instead of writing three almost-identical ACI resource blocks, we describe
# our regional design once as a Terraform map.
#
# The keys:
#
#   eus
#   weu
#   sea
#
# become stable Terraform instance identifiers.
#
# Later:
#
#   for_each = local.endpoints
#
# causes Terraform to create one instance per map entry.
#
# Example Terraform addresses:
#
#   azurerm_container_group.regional["eus"]
#   azurerm_container_group.regional["weu"]
#   azurerm_container_group.regional["sea"]
#
# This is the same for_each pattern introduced in Lab 01.
#
# =============================================================================

locals {
  endpoints = {

    # -------------------------------------------------------------------------
    # EAST US
    # -------------------------------------------------------------------------
    #
    # Geographic mapping:
    # GEO-NA = North America
    #
    eus = {
      location       = "eastus"
      container_name = "ci-az700-tm-eus"

      # Terraform interpolates var.dns_suffix into the string.
      #
      # Example:
      # dns_suffix = 87004
      #
      # Result:
      # az700-tm-eus-87004
      #
      dns_label = "az700-tm-eus-${var.dns_suffix}"

      endpoint_name = "ep-eus"

      geo_mappings = [
        "GEO-NA"
      ]
    }


    # -------------------------------------------------------------------------
    # WEST EUROPE
    # -------------------------------------------------------------------------
    #
    # Geographic mapping:
    # GEO-EU = Europe
    #
    weu = {
      location       = "westeurope"
      container_name = "ci-az700-tm-weu"
      dns_label      = "az700-tm-weu-${var.dns_suffix}"
      endpoint_name  = "ep-weu"

      geo_mappings = [
        "GEO-EU"
      ]
    }


    # -------------------------------------------------------------------------
    # SOUTHEAST ASIA
    # -------------------------------------------------------------------------
    #
    # GEO-AS = Asia
    # GEO-AP = Australia / Pacific
    #
    # This is an important lesson from the manual deployment.
    #
    # Initially we mapped only GEO-AS.
    #
    # Our Australian DNS resolver received no eligible endpoint because
    # Australia/Pacific belongs to GEO-AP rather than GEO-AS.
    #
    # We therefore deliberately map BOTH GEO-AS and GEO-AP to this endpoint.
    #
    sea = {
      location       = "southeastasia"
      container_name = "ci-az700-tm-sea"
      dns_label      = "az700-tm-sea-${var.dns_suffix}"
      endpoint_name  = "ep-sea"

      geo_mappings = [
        "GEO-AS",
        "GEO-AP"
      ]
    }
  }
}


# =============================================================================
# SECTION 2 - RESOURCE GROUP
# =============================================================================
#
# The resource group provides the Azure management boundary for the lab.
#
# The resource group's location is Australia East.
#
# IMPORTANT:
#
# This does NOT mean Traffic Manager operates only in Australia East.
#
# Traffic Manager is a GLOBAL Azure service.
#
# The resource-group location is primarily where Azure stores resource-group
# metadata.
#
# Terraform address:
#
#   azurerm_resource_group.lab
#
# Actual Azure name:
#
#   rg-az700-tm-global
#
# =============================================================================

resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


# =============================================================================
# SECTION 3 - REGIONAL AZURE CONTAINER INSTANCES
# =============================================================================
#
# We need real HTTP endpoints in three Azure regions for Traffic Manager
# to monitor and return through DNS.
#
# The original reference lab used Azure App Service.
#
# During our manual deployment, the subscription had:
#
#   App Service VM quota = 0
#
# Instead of abandoning the networking lesson, we deliberately substituted
# Azure Container Instances.
#
# Traffic Manager only needs reachable endpoints.
#
# This keeps the Traffic Manager networking lesson intact.
#
#
# for_each
# --------
#
# Terraform reads:
#
#   local.endpoints
#
# and creates:
#
#   regional["eus"]
#   regional["weu"]
#   regional["sea"]
#
#
# DEPENDENCY:
#
# resource_group_name = azurerm_resource_group.lab.name
#
# is a Terraform reference.
#
# Because of that reference Terraform automatically understands:
#
#   Resource Group
#       |
#       +--> ACI East US
#       +--> ACI West Europe
#       +--> ACI Southeast Asia
#
# No explicit depends_on is required.
#
# =============================================================================

resource "azurerm_container_group" "regional" {
  for_each = local.endpoints

  # Values are taken from whichever local.endpoints item Terraform
  # is currently processing.
  name                = each.value.container_name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.lab.name

  # Give each container group a public Azure IP address.
  ip_address_type = "Public"

  # Creates a stable public DNS hostname for the ACI instance.
  #
  # Example:
  #
  # az700-tm-sea-87004.southeastasia.azurecontainer.io
  #
  # Traffic Manager will target this FQDN rather than the ACI public IP.
  #
  # That distinction matters because during our manual failure test the
  # Southeast Asia ACI public IP changed after stop/start.
  #
  # The FQDN is therefore the better endpoint identity.
  #
  dns_name_label = each.value.dns_label

  # Our container image runs Linux.
  os_type = "Linux"

  # Explicitly document the expected restart behaviour.
  restart_policy = "Always"


  # ---------------------------------------------------------------------------
  # CONTAINER DEFINITION
  # ---------------------------------------------------------------------------
  #
  # This reproduces the small web container used during the manual lab.
  #
  container {
    name  = "web"
    image = var.container_image

    # Small resource allocation keeps this lab lightweight.
    cpu    = 0.5
    memory = 0.5


    # -------------------------------------------------------------------------
    # HTTP PORT
    # -------------------------------------------------------------------------
    #
    # The application listens over HTTP/80.
    #
    # Traffic Manager's health probe will also test HTTP/80.
    #
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}


# =============================================================================
# SECTION 4 - AZURE TRAFFIC MANAGER PROFILE
# =============================================================================
#
# This is the DNS steering service at the centre of the lab.
#
# Azure resource name:
#
#   tm-az700-global
#
# Public DNS name:
#
#   az700-tm-md-<suffix>.trafficmanager.net
#
#
# Geographic routing means:
#
#   DNS source geography
#             |
#             v
#   Geographic mapping
#             |
#             v
#   Eligible endpoint
#
#
# IMPORTANT:
#
# Geographic routing does NOT mean:
#
#   "send the user to the geographically nearest datacenter"
#
# That mental model is closer to Traffic Manager PERFORMANCE routing.
#
# Geographic routing uses explicitly configured geography-to-endpoint
# mappings.
#
# =============================================================================

resource "azurerm_traffic_manager_profile" "global" {

  # Azure resource name.
  name = "tm-az700-global"

  # Reference to the resource group creates another implicit dependency.
  resource_group_name = azurerm_resource_group.lab.name

  # We are deliberately reproducing the Geographic routing method
  # from the manual deployment.
  traffic_routing_method = "Geographic"


  # ---------------------------------------------------------------------------
  # DNS CONFIGURATION
  # ---------------------------------------------------------------------------
  #
  # relative_name creates:
  #
  # az700-tm-md-87004.trafficmanager.net
  #
  # when dns_suffix = 87004.
  #
  dns_config {
    relative_name = "az700-tm-md-${var.dns_suffix}"

    # Authoritative Traffic Manager TTL.
    #
    # During the manual lab we verified:
    #
    # Traffic Manager authoritative DNS = 30 seconds
    #
    # but our AdGuard recursive resolver returned 60 seconds.
    #
    # This demonstrated that recursive DNS behaviour can influence the
    # effective caching period observed by clients.
    #
    ttl = 30
  }


  # ---------------------------------------------------------------------------
  # ENDPOINT HEALTH MONITORING
  # ---------------------------------------------------------------------------
  #
  # Traffic Manager independently probes each regional endpoint.
  #
  # Health monitoring influences whether an endpoint is considered healthy.
  #
  monitor_config {

    # Perform an HTTP request.
    protocol = "HTTP"

    # Probe the web service on port 80.
    port = 80

    # Request the root page.
    path = "/"

    # Probe every 30 seconds.
    interval_in_seconds = 30

    # Wait up to 10 seconds for each probe response.
    timeout_in_seconds = 10

    # Three failed probes are tolerated before the endpoint is considered
    # unhealthy/degraded.
    tolerated_number_of_failures = 3
  }
}


# =============================================================================
# SECTION 5 - TRAFFIC MANAGER EXTERNAL ENDPOINTS
# =============================================================================
#
# Traffic Manager now needs to know where each regional application lives.
#
# Because our backend services are Azure Container Instance FQDNs rather
# than Azure Traffic Manager's Azure-endpoint resource type, we register
# them as EXTERNAL endpoints.
#
#
# Once again we use:
#
#   for_each = local.endpoints
#
# This creates:
#
#   regional["eus"]
#   regional["weu"]
#   regional["sea"]
#
#
# The important dependency chain is:
#
#        Traffic Manager profile
#                 |
#                 |
#                 v
#        Traffic Manager endpoint
#                 ^
#                 |
#                 |
#             ACI FQDN
#
#
# Terraform can infer both dependencies from these references:
#
#   profile_id = azurerm_traffic_manager_profile.global.id
#
#   target = azurerm_container_group.regional[each.key].fqdn
#
# =============================================================================

resource "azurerm_traffic_manager_external_endpoint" "regional" {
  for_each = local.endpoints

  # ep-eus / ep-weu / ep-sea
  name = each.value.endpoint_name

  # Connect this endpoint to our Traffic Manager profile.
  #
  # This reference means the profile must exist before Terraform can
  # create the endpoint.
  #
  profile_id = azurerm_traffic_manager_profile.global.id

  # Target the FQDN exported by the matching ACI resource.
  #
  # each.key keeps the instances aligned:
  #
  # eus -> ACI eus
  # weu -> ACI weu
  # sea -> ACI sea
  #
  target = azurerm_container_group.regional[each.key].fqdn

  # Explicitly keep the endpoint administratively enabled.
  #
  # Note the difference between:
  #
  # Enabled  = administrative state
  # Online   = health state
  # Degraded = health problem detected
  #
  enabled = true

  # Geographic mappings come directly from our regional data model.
  #
  # eus -> GEO-NA
  # weu -> GEO-EU
  # sea -> GEO-AS + GEO-AP
  #
  geo_mappings = each.value.geo_mappings
}


# =============================================================================
# TERRAFORM RESOURCE GRAPH - SUMMARY
# =============================================================================
#
# Terraform effectively derives this dependency graph:
#
#
#                   azurerm_resource_group.lab
#                         /             \
#                        /               \
#                       v                 v
#              ACI regional[]      Traffic Manager profile
#                    \                   /
#                     \                 /
#                      \               /
#                       v             v
#                   Traffic Manager endpoints[]
#
#
# Terraform does NOT use the visual order of this file to decide
# creation order.
#
# It follows references and builds a dependency graph.
#
#
# =============================================================================
# EXPECTED FINAL ARCHITECTURE
# =============================================================================
#
#                    az700-tm-md-87004
#                     .trafficmanager.net
#                              |
#                    Geographic Routing
#                              |
#              +---------------+---------------+
#              |               |               |
#           ep-eus          ep-weu          ep-sea
#          GEO-NA           GEO-EU       GEO-AS/GEO-AP
#              |               |               |
#              v               v               v
#          East US         West Europe    Southeast Asia
#             ACI              ACI              ACI
#              |               |               |
#              +-------- HTTP port 80 ----------+
#
#
# Client data flow:
#
# Client
#   |
#   | DNS query
#   v
# Recursive DNS resolver
#   |
#   v
# Traffic Manager
#   |
#   | DNS response containing selected endpoint
#   v
# Client
#   |
#   | HTTP connection - DIRECT
#   v
# Selected regional ACI
#
#
# Traffic Manager is therefore:
#
#       CONTROL / DNS STEERING PLANE
#
# and NOT:
#
#       APPLICATION DATA PLANE
#
# =============================================================================