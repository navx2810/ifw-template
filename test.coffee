compile = require './main.coffee'

test_data = 
	characters: [(id: 'apple', attributes: [(key: "Nickname", type: "Paragraph", default_value: "carrrl"), (key: "Description", type: "int", default_value: 50)], curves: [(damage: 40, cost:200, notifier: true), (damage: 90, cost:500, notifier: true), (damage: 150, cost:1000, notifier: false)])]


compile(test_data, "C:/project/")