# Blackjack

A single-player Blackjack game built with Phoenix LiveView. Play against an automated dealer entirely in the browser — no database, no page reloads, all game state held in LiveView socket assigns.

Built as a portfolio project to practice Elixir, Phoenix LiveView, and ExUnit testing.

## Features

- Full Blackjack game loop: deal, hit, stand, win/lose/tie detection
- Dealer plays automatically using standard casino rules (hits until 17+)
- Proper ace handling (counts as 11, or 1 if it would otherwise bust the hand)
- Real-time UI updates via Phoenix LiveView — no JavaScript required
- Game state held entirely in socket assigns (no database/Ecto)
- Test suite covering core game logic

## Tech Stack

- [Elixir](https://elixir-lang.org/)
- [Phoenix Framework](https://www.phoenixframework.org/) (`--no-ecto`)
- [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view)
- ExUnit for testing

## Game Logic

All core Blackjack rules live in `Blackjack.Game` — a pure, dependency-free module with no knowledge of LiveView or the web layer. This keeps the game logic easy to test in isolation.

| Function | Description |
|---|---|
| `new_deck/0` | Builds a standard 52-card deck using a list comprehension |
| `shuffle_deck/1` | Returns a randomly shuffled deck |
| `deal_card/1` | Deals the top card, returns `{card, remaining_deck}` |
| `deal_initial_hand/1` | Deals 2 cards, returns `{hand, remaining_deck}` |
| `card_value/1` | Returns the point value of a single card |
| `hand_value/1` | Sums a hand's value, adjusting for a flexible ace |
| `card_to_string/1` | Converts a card tuple into a readable string (e.g. `"Ace of Hearts"`) |
| `determine_winner/2` | Compares player and dealer hands, returns `:player`, `:dealer`, or `:tie` |

Cards are represented as simple tuples, e.g. `{:hearts, :ace}` or `{:spades, 7}`.

## LiveView Layer

`BlackjackWeb.BlackjackLive` handles all game flow and UI:

- `mount/3` — shuffles a new deck and deals starting hands when the page loads
- `handle_event("hit", ...)` — deals a card to the player, checks for a bust
- `handle_event("stand", ...)` — runs the dealer's turn (recursive `dealer_play/2` helper), then determines the winner
- `handle_event("new_game", ...)` — resets the table for a new round
- `render/1` — displays both hands, scores, and the result of the round

## Getting Started

### Prerequisites

- Elixir & Erlang installed
- Phoenix installed (`mix archive.install hex phx_new`)

### Setup

```bash
git clone https://github.com/Josh-Odahara/blackjack.git
cd blackjack
mix deps.get
mix phx.server
```

Then visit [`http://localhost:4000/blackjack`](http://localhost:4000/blackjack) in your browser.

### Running Tests

```bash
mix test
```

## Roadmap

- [ ] Tailwind styling for a proper card-table look
- [ ] Claude-powered dealer (AI dealer turn via the Anthropic API, using `Task.async` + `handle_info`)
- [ ] Visual card assets instead of text-based cards
- [ ] Bankroll / betting system

## About

Built by [Josh Odahara](https://github.com/Josh-Odahara) while learning Elixir and Phoenix LiveView, transitioning from a non-engineering background toward a junior developer role.
