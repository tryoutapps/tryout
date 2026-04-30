import random

ICONS = ["triangle", "circle", "square", "star"]

def generate_grid(size: int = 20):
    grid = [
        [random.choice(ICONS) for _ in range(size)]
        for _ in range(size)
    ]

    target = random.choice(ICONS)

    return grid, target
