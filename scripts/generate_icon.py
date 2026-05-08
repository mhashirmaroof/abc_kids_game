"""Generate a 1024x1024 app icon for ABC Kids: Tap & Learn."""
import math
import os

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Pillow not installed. Run: pip3 install pillow")
    exit(1)

SIZE = 1024
img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Blue background circle
M = 40
draw.ellipse([M, M, SIZE - M, SIZE - M], fill=(77, 150, 255, 255))
draw.ellipse([80, 80, SIZE - 80, SIZE - 80], outline=(255, 255, 255, 60), width=18)

# Fonts
try:
    f1 = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 280)
    f2 = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 140)
except Exception:
    f1 = ImageFont.load_default()
    f2 = f1

# "ABC" text with shadow
draw.text((SIZE // 2 + 6, SIZE // 2 - 120 + 6), "ABC", font=f1, fill=(0, 0, 0, 60), anchor="mm")
draw.text((SIZE // 2, SIZE // 2 - 120), "ABC", font=f1, fill=(255, 255, 255, 255), anchor="mm")

# "Kids" text with shadow
draw.text((SIZE // 2 + 3, SIZE // 2 + 130 + 3), "Kids", font=f2, fill=(0, 0, 0, 50), anchor="mm")
draw.text((SIZE // 2, SIZE // 2 + 130), "Kids", font=f2, fill=(255, 220, 61, 255), anchor="mm")

# Decorative dots (red, green, yellow)
for color, angle in [((255, 107, 107), 210), ((107, 203, 119), 270), ((255, 220, 61), 330)]:
    rad = math.radians(angle)
    cx = SIZE // 2 + int(350 * math.cos(rad))
    cy = SIZE // 2 + int(350 * math.sin(rad))
    draw.ellipse([cx - 28, cy - 28, cx + 28, cy + 28], fill=(*color, 230))

os.makedirs("assets/icon", exist_ok=True)
img.save("assets/icon/app_icon.png")
print("✅ assets/icon/app_icon.png generated (1024x1024)")
