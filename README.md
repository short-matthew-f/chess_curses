# chess.rb

An implementation of chess in ruby, without AI

# to play

    loop do
        ruby chess.rb
        enjoy
    end

# what we've accomplished

## implemented pieces

Chess pieces are weird because there are many different ways they move.

- Knights and kings are jumpers: they have a list of places they can go, and can't do anything about it.
- Queens, Rooks and Bishops are sliders: they pick a direction and can go until they run into something.
- Pawns are ... well, pawns.  They can move in one direction, unless they are attacking and then they move in an entirely different direction. 

In addition to knowing how to move, they also know how to render themselves.  It's cute, and uses Unicode.

## implemented a board class

The chess board does a fair bit of lifting for us. 

- It reports back subsets of the pieces still on it
- It can see if a color is in check.
- It actually removes pieces and places them an a new square for us.
- Renders prettily with color scheme.
- Keep track of and displays captured pieces.

## implemented a main game class, Chess

The Chess class does all of the game logic.

- It checks to see if we're in checkmate.
- It does error handling for user input.
- It parses 'nice' input (e.g. `E4 => [4, 4]`) 
- Can save/load/quit during gameplay.

# TODO

- Add castling
- Add en pessant
- Add promotion
- Add specific error types, rather than just using StandardError over and over.

# TODO in the year 3000

- Port code to `jruby` and make the interface swank in an 'embeddable in a webpage' sorta way.
- Maybe play with `curses` gem to make the interface swank in shell.