biojs-vis-easy_feature
==========

A super simple feature component written in CoffeeScript. 

[![Build Status](https://drone.io/github.com/greenify/biojs-vis-easy_feature/status.png)](https://drone.io/github.com/greenify/biojs-vis-easy_feature/latest)
[![NPM version](http://img.shields.io/npm/v/biojs-vis-easy_feature.svg)](https://www.npmjs.org/package/biojs-vis-easy_feature)
[![Dependencies](https://david-dm.org/greenify/biojs-vis-easy_feature.png)](https://david-dm.org/greenify/biojs-vis-easy_feature)
[![Code Climate](https://codeclimate.com/github/greenify/biojs-vis-easy_feature/badges/gpa.svg)](https://codeclimate.com/github/greenify/biojs-vis-easy_feature)
[![NPM downloads](http://img.shields.io/npm/dm/biojs-vis-easy_feature.svg)](https://www.npmjs.org/package/biojs-vis-easy_feature)

![example](http://i.imgur.com/tbubDoB.png "Easy feature component")

You can __fetch prebuilt files__ [here](https://drone.io/github.com/greenify/biojs-vis-easy_feature/files)

Example
--------------

```
<script src="build/biojs_vis_easy_features.min.js"></script>
<div id='feature'></div>
<script>
var Feature = biojs.vis.easy_features.model;

// features
var f1 = new Feature(2,20,"easy", "red");
var f2 = new Feature(5,20,"component", "green");
var f3 = new Feature(21,30,"feature", "blue");


var msa = new biojs.vis.easy_features.stage('feature',[f1,f2,f3]);

msa.on("all", function(eventName, arg){
	console.log(eventName)
	console.log(arg)
})
</script>
```

npm
-----

Yes you can just require this with npm.

```
var Feature = require("biojs-vis-easy_feature").model;
var stage = require("biojs-vis-easy_feature").stage;
```


Feature object
--------------

Constructor:

```
new Feature(xStart, xEnd, text, fillColor)
```

Entire object with default values.

```
xStart: -1
xEnd: -1
height: -1
text: ""
fillColor: "red"
fillOpacity: 0.5
type: "rectangle"
borderSize: 1
borderColor: "black"
borderOpacity: 0.5
```
