from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import math
import textwrap

OUT = Path("labs/02-traffic-manager/visual-learning")
OUT.mkdir(parents=True, exist_ok=True)
W, H = 1600, 900


def font(size: int, bold: bool = False):
    candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation2/LiberationSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
    ]
    for candidate in candidates:
        if Path(candidate).exists():
            return ImageFont.truetype(candidate, size)
    return ImageFont.load_default()


F_TITLE = font(46, True)
F_H = font(30, True)
F = font(24)
F_S = font(20)
F_B = font(23, True)


def box(draw, xy, title, lines=None, radius=20):
    draw.rounded_rectangle(xy, radius=radius, outline="black", width=3, fill="white")
    x1, y1, x2, y2 = xy
    draw.text((x1 + 18, y1 + 15), title, font=F_B, fill="black")
    yy = y1 + 58
    if lines:
        for line in lines:
            for wrapped in textwrap.wrap(line, width=max(20, int((x2 - x1) / 13))):
                draw.text((x1 + 18, yy), wrapped, font=F_S, fill="black")
                yy += 28
            yy += 4


def arrow(draw, p1, p2, width=5):
    draw.line([p1, p2], fill="black", width=width)
    ang = math.atan2(p2[1] - p1[1], p2[0] - p1[0])
    length = 18
    points = [
        p2,
        (p2[0] - length * math.cos(ang - 0.5), p2[1] - length * math.sin(ang - 0.5)),
        (p2[0] - length * math.cos(ang + 0.5), p2[1] - length * math.sin(ang + 0.5)),
    ]
    draw.polygon(points, fill="black")


def save(img, name):
    img.save(OUT / name, "PNG", optimize=True)


# Visual 01 — DNS mental model
img = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(img)
d.text((55, 35), "Lab 02 — Traffic Manager DNS Mental Model", font=F_TITLE, fill="black")
d.text((55, 100), "Traffic Manager makes the DNS decision; it is not in the final HTTP data path.", font=F, fill="black")
box(d, (70, 210, 350, 390), "Client", ["Browser / workstation"])
box(d, (470, 210, 770, 390), "Recursive DNS Resolver", ["e.g. AdGuard or Google DNS"])
box(d, (890, 180, 1490, 420), "Azure Traffic Manager", ["tm-az700-global", "az700-tm-md-87004.trafficmanager.net", "Routing method: Geographic"])
arrow(d, (350, 300), (470, 300))
arrow(d, (770, 300), (890, 300))
d.text((385, 258), "DNS query", font=F_S, fill="black")
d.text((790, 258), "DNS query", font=F_S, fill="black")
arrow(d, (890, 360), (770, 360))
arrow(d, (470, 360), (350, 360))
d.text((778, 372), "DNS answer → selected endpoint", font=F_S, fill="black")
box(d, (1010, 570, 1490, 790), "Selected regional ACI endpoint", ["Example for GEO-AP:", "az700-tm-sea-87004.southeastasia.azurecontainer.io", "HTTP port 80"])
arrow(d, (350, 610), (1010, 680), width=6)
d.text((505, 610), "APPLICATION DATA FLOW — client connects DIRECTLY to selected ACI", font=F_B, fill="black")
d.text((505, 655), "Traffic Manager is not crossed by this HTTP connection.", font=F, fill="black")
save(img, "Lab02-01-Traffic-Manager-DNS-Mental-Model.png")


# Visual 02 — Geographic routing
img = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(img)
d.text((55, 35), "Lab 02 — Geographic Routing Flow", font=F_TITLE, fill="black")
box(d, (560, 135, 1040, 300), "Traffic Manager", ["Geographic routing", "Decision is based on DNS query / resolver geography"])
regions = [
    (70, 430, 350, 720, "North America", "GEO-NA", "ep-eus", "East US ACI"),
    (430, 430, 710, 720, "Europe", "GEO-EU", "ep-weu", "West Europe ACI"),
    (790, 430, 1070, 720, "Asia", "GEO-AS", "ep-sea", "Southeast Asia ACI"),
    (1150, 430, 1530, 720, "Australia / Pacific", "GEO-AP", "ep-sea", "Southeast Asia ACI"),
]
for x1, y1, x2, y2, region, geo, endpoint, app in regions:
    box(d, (x1, y1, x2, y2), region, [geo, f"{endpoint} → {app}"])
    arrow(d, (800, 300), ((x1 + x2) // 2, y1))
d.text((80, 770), "Failure discovered:", font=F_B, fill="black")
d.text((80, 810), "With only GEO-AS configured on ep-sea, the Australian lookup returned no eligible endpoint.", font=F, fill="black")
d.text((80, 850), "Fix: ep-sea geoMapping = GEO-AS + GEO-AP. Geographic routing ≠ 'closest endpoint'.", font=F, fill="black")
save(img, "Lab02-02-Geographic-Routing-Flow.png")


# Visual 03 — Endpoint health and DNS behaviour
img = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(img)
d.text((55, 35), "Lab 02 — Endpoint Health and DNS Behaviour", font=F_TITLE, fill="black")
for x, title in [(50, "1. Healthy baseline"), (555, "2. Failure"), (1060, "3. Recovery")]:
    d.rounded_rectangle((x, 130, x + 450, 770), radius=20, outline="black", width=3, fill="white")
    d.text((x + 20, 150), title, font=F_H, fill="black")
d.text((75, 230), "ep-eus  Online", font=F, fill="black")
d.text((75, 275), "ep-weu  Online", font=F, fill="black")
d.text((75, 320), "ep-sea  Online", font=F, fill="black")
d.text((75, 395), "GEO-AP → ep-sea", font=F_B, fill="black")
d.text((75, 440), "DNS returns Southeast Asia", font=F, fill="black")
d.text((75, 485), "HTTP works", font=F, fill="black")
d.text((580, 230), "ci-az700-tm-sea stopped", font=F, fill="black")
arrow(d, (760, 275), (760, 330))
d.text((580, 350), "ep-sea = Degraded", font=F_B, fill="black")
arrow(d, (760, 400), (760, 455))
d.text((580, 475), "Fresh DNS query still", font=F, fill="black")
d.text((580, 515), "returns ep-sea for GEO-AP", font=F, fill="black")
arrow(d, (760, 565), (760, 620))
d.text((580, 640), "HTTP times out", font=F_B, fill="black")
d.text((580, 700), "NO cross-geography failover", font=F_B, fill="black")
d.text((1085, 230), "ci-az700-tm-sea started", font=F, fill="black")
arrow(d, (1270, 275), (1270, 330))
d.text((1085, 350), "HTTP works again", font=F_B, fill="black")
arrow(d, (1270, 400), (1270, 455))
d.text((1085, 475), "ep-sea returns Online", font=F_B, fill="black")
d.text((1085, 555), "ACI public IP changed", font=F, fill="black")
d.text((1085, 595), "FQDN remained the target", font=F, fill="black")
d.text((55, 805), "Different timers:", font=F_B, fill="black")
d.text((250, 805), "Traffic Manager configured / authoritative TTL = 30s", font=F_S, fill="black")
d.text((790, 805), "AdGuard-presented CNAME TTL = 60s", font=F_S, fill="black")
d.text((1200, 805), "ACI A-record TTL observed = 300s", font=F_S, fill="black")
d.text((55, 850), "Health probe interval observed in Portal = 30s; tolerated failures = 3; timeout = 10s.", font=F_S, fill="black")
save(img, "Lab02-03-Endpoint-Health-and-DNS-Behaviour.png")


# Visual 04 — Final architecture
img = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(img)
d.text((55, 35), "Lab 02 — Final Manual Architecture", font=F_TITLE, fill="black")
d.text((55, 95), "Resource group: rg-az700-tm-global (manual environment later deleted)", font=F, fill="black")
box(d, (500, 150, 1100, 365), "Azure Traffic Manager — tm-az700-global", ["FQDN: az700-tm-md-87004.trafficmanager.net", "Routing: Geographic | DNS TTL: 30s", "Monitor: HTTP :80 / | interval 30s | failures 3 | timeout 10s"])
endpoints = [
    (60, 500, 480, 800, "East US", "ep-eus / GEO-NA", "ci-az700-tm-eus", "az700-tm-eus-87004.eastus.azurecontainer.io"),
    (590, 500, 1010, 800, "West Europe", "ep-weu / GEO-EU", "ci-az700-tm-weu", "az700-tm-weu-87004.westeurope.azurecontainer.io"),
    (1120, 500, 1540, 800, "Southeast Asia", "ep-sea / GEO-AS + GEO-AP", "ci-az700-tm-sea", "az700-tm-sea-87004.southeastasia.azurecontainer.io"),
]
for x1, y1, x2, y2, region, endpoint, container, fqdn in endpoints:
    box(d, (x1, y1, x2, y2), region, [endpoint, container, fqdn, "Public HTTP :80", "Traffic Manager target = FQDN"])
    arrow(d, (800, 365), ((x1 + x2) // 2, y1))
d.text((55, 840), "DNS chooses an endpoint; the client's HTTP connection then goes directly to that ACI endpoint.", font=F_B, fill="black")
save(img, "Lab02-04-Final-Lab-Architecture.png")

print("Generated Lab 02 visual-learning PNGs:")
for name in sorted(p.name for p in OUT.glob("Lab02-*.png")):
    print(name)
