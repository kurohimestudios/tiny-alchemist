#Game Design Document: Tiny Alchemist

##Engine: Godot 4.6 Genre: Idle / Incremental Platform: PC / Web Target Audience: Casual players / Strategy fans

---

##1. Game Overview

**Tiny Alchemist** is a relaxed idle game where the player manages a magical workshop. The goal is to gather herbs, brew potions, and sell them for gold to automate the process.

**The Core Loop**
**Gather**: Click to harvest raw ingredients (Herbs).

**Process**: Convert ingredients into products (Potions).

**Sell**: Sell products for currency (Gold).

**Upgrade**: Spend Gold to automate gathering and brewing.

**Prestige**: Reset progress for "Philosopher's Stones" (global multiplier).

---

##2. Mechanics & Systems

###A. Resources (The Economy)

To keep the scope manageable for learning, we will use a 3-Tier Economy:

- **Raw Material**: Moonleaf (Generated via clicking or auto-gardeners).

- **Processed Goods**: Mana Potion (Cost: 5 Moonleaf).

- **Currency**: Gold (Earned by selling Potions).

###B. Active Gameplay (The Clicker)

- **The Garden Bed**: A button the player clicks to gain +1 Moonleaf.

- **The Cauldron**: A button the player clicks to convert 5 Moonleaf into 1 Mana Potion.

- **The Shop Counter**: A button to sell 1 Mana Potion for 10 Gold.

###C. Passive Gameplay (Automation)

The player buys "Units" to do the work for them.

- **Apprentice Gardener**: Automatically gathers 1 Moonleaf per second.

- **Auto-Stirrer**: Automatically brews 1 Potion every 2 seconds (consumes herbs automatically).

- **Merchant**: Automatically sells 1 Potion per second.

###D. Upgrades (Scaling)

Upgrades are one-time purchases that modify the variables of the Units.

- **Sharper Sickles**: Apprentice Gardeners gather x2 Moonleaf.

- **Hotter Flame**: Auto-Stirrers brew 50% faster.

###E. Prestige (Rebirth)

- **Condition**: Unlockable after earning 10,000 Gold total.

- **Reward**: Reset all Gold, Herbs, Potions, and Units. Gain Philosopher's Stones.

- **Effect**: Each Stone gives a +10% bonus to global production speed.

---

##3. UI/UX Design

Since this is an Idle game, UI is the game.

###Layout (Screen Split)
- ####Left Panel (The Workshop):

	- Large interactive buttons (Garden, Cauldron, Market).

	- Visual representation of current resources (Labels).

- ####Right Panel (The Shop):

	- ScrollContainer containing buyable Units.

	- ScrollContainer containing Upgrades.

- ####Top Bar:

	- Global Stats (Total Gold, Current Prestige Multiplier).

---

##4. Technical Implementation (Godot Focused)

This section highlights the specific Godot features you will practice with this project.

###A. Node Structure

Use a main `Control` node as the root.

`Main (Control)
├── GameState (Node) --> Holds variables (gold, herbs, prestige)
├── Background (TextureRect)
├── HUD (HBoxContainer)
│   ├── LeftPanel (VBoxContainer) --> Active Buttons
│   │   ├── ResourceDisplay (Label)
│   │   ├── GatherButton (Button)
│   │   └── BrewButton (Button)
│   └── RightPanel (TabContainer) --> Upgrades/Shop
│       ├── UnitsTab (VBoxContainer)
│       └── UpgradesTab (VBoxContainer)
└── Systems (Node)
    ├── AutoGatherTimer (Timer)
    └── AutoBrewTimer (Timer)`

###B. Data Management: Custom Resources (`.tres`)

This is the key learning objective. Instead of hardcoding every upgrade in code, you will create a script `UpgradeItem.gd` that extends `Resource`.

File: `UpgradeItem.gd`

`extends Resource
class_name UpgradeItem

@export var name: String
@export var base_cost: int
@export var multiplier: float
@export var icon: Texture2D`

Why? You can now right-click in the Godot FileSystem, create "New Resource," and make as many upgrades as you want without writing new code.

###C. Signals (The Observer Pattern)

Use Signals to decouple your logic.

- GameState emits resource_changed(resource_name, new_amount).

- UI Labels connect to resource_changed to update text.

- Buttons connect to pressed to tell GameState to modify values.

###D. Save System

Implement a simple save system using `FileAccess`. Use a Dictionary to store values and save it as JSON.

Path: `user://savegame.json`

---

##5. Development Roadmap (Step-by-Step)

###Phase 1: The Clicker (Minimum Viable Product)

- Set up the Godot project.

- Create the GameState singleton (Autoload).

- Create the UI with basic Buttons.

- Program the logic: Clicking "Gather" adds +1 to the Herb variable. Update the Label.

###Phase 2: The Loop

- Implement the Cauldron (Conversion logic: if herbs >= 5: herbs -= 5; potions += 1).

- Implement the Market (Sell logic).

- Add "Floating Text" feedback when clicking (instantiate a label at mouse position).

###Phase 3: Automation

- Add Timer nodes.

- Create the Logic: _on_timer_timeout(): herbs += gardener_count.

- Create a Shop UI to buy "Gardeners" which increases gardener_count.

###Phase 4: Data & Polish

- Refactor upgrades to use Custom Resources.

- Implement the Save/Load system.

- Add basic sound effects (pop, coin chink).

---

##6. Art & Audio Style

- **Visuals**: Minimalist Pixel Art (16x16 icons scaled up).

	- Colors: Green (Herbs), Blue (Potions), Yellow (Gold).
	
	- The link for the reference will be add here

- **Audio**: Satisfying "pops" for gathering, bubbling sounds for brewing, and a "cha-ching" for selling.
