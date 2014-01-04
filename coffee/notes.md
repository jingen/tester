# tips for coffee
- 1) coffee REPL: coffee enter
- 2) node example.js
- 3) coffee example.coffee
- 4) compile coffee files to js files
     coffee -c example.coffee example.js
- 5) prevent coffee from not wrapping your file with anonymous function
(......).call(this)
     coffee -c --bare example.coffee


- 6) npm install -g coffee-script

- 7) watch changes made on coffeescript and recompile them in real time
coffee -cw *.coffee
    #coffee -c --watch *.coffee
coffee -cw -o js coffee/*.coffee
    #coffee -c --watch -o js coffee/*.coffee
    # -o js(output directory) coffee/*.coffee (input files)

