from pathlib import Path

# Historical helper retained for compatibility.
# The active generator now lives with the Microsoft Learn unit that owns it.
TARGET = Path("modules/04-load-balance-non-http-traffic-in-azure/06-exercise-create-a-traffic-manager-profile-using-the-azure-portal/practical/visual-learning/generate_visuals.py")

if __name__ == "__main__":
    raise SystemExit(
        "Run the unit-local generator instead: " + str(TARGET)
    )
