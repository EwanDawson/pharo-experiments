Class {
	#name : #LazyRoassal2,
	#superclass : #Object,
	#category : #'Lazygun-Experiments'
}

{ #category : #examples }
LazyRoassal2 class >> earthquakeMap [
	"Geographical CSV data"

	<sampleInstance>
	| tab b |
	tab := RTTabTable new
		input:
			'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.csv'
				asUrl retrieveContents
		usingDelimiter: $,.
	tab removeFirstRow.
	tab replaceEmptyValuesWith: '0' inColumns: #(2 3 4 5).
	tab convertColumnsAsFloat: #(2 3 4 5).
	b := RTMapLocationBuilder new.
	b shape circle
		size: [ :m | 2 raisedTo: m - 1 ];
		color: (Color red alpha: 0.3).
	tab
		values do: [ :row | b addPoint: row second @ row third value: row fifth ].
	^ b
]

{ #category : #examples }
LazyRoassal2 class >> earthquakeTimeline [
	"Timeline of seismic activity"

	<sampleInstance>
	| tab v es |
	tab := RTTabTable new
		input:
			'http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.csv'
				asUrl retrieveContents
		usingDelimiter: $,.
	tab removeFirstRow.
	tab
		convertColumn: 1
		to: [ :s | (DateAndTime fromString: s) julianDayNumber ].
	tab convertColumnsAsFloat: #(5).
	v := RTView new.
	es := RTEllipse elementsOn: tab values.
	v addAll: es.
	es @ RTPopup.
	RTMetricNormalizer new
		elements: es;
		normalizeColor: #fifth
			using:
			{Color orange.
			Color red};
		alphaColor: 0.3;
		normalizeX: #first min: 0 max: 600;
		normalizeSize: #fifth
			min: 0
			max: 80
			using: [ :mag | 2 raisedTo: mag - 1 ].
	es
		@
			(RTLabeled new
				text: [ :row | 
					row fifth > 6
						ifTrue: [ row fifth ]
						ifFalse: [ '' ] ]).
	v @ RTDraggableView.
	^ v
]

{ #category : #examples }
LazyRoassal2 class >> ebolaPlot [

	<sampleInstance>
	| tab b data ds |
	"Preparing the data"
	tab := RTTabTable new
		input: 'http://agilevisualization.com/Ebola2.csv' asUrl retrieveContents
		usingDelimiter: $,.
	tab removeFirstRow.
	tab replaceEmptyValuesWith: '0' inColumns: #(10 11).
	tab convertColumnsAsInteger: #(10 11).
	tab convertColumnsAsDateAndTime: #(3 4).
	data := tab values reversed.

	"Charting the data"
	b := RTGrapher new.
	ds := RTData new.
	ds interaction fixedPopupText: [ :row | row value at: 12 ].
	ds dotShape ellipse
		color: (Color blue alpha: 0.3);
		size: [ :row | (row at: 11) / 5 ].
	ds points: data.
	ds connectColor: Color blue.
	ds y: [ :r | r at: 10 ].
	ds
		highlightIf: [ :row | (row at: 10) > 100 ]
		using: [ :row | row third year ].
	b add: ds.
	b axisX
		noLabel;
		numberOfTicks: tab values size.
	b axisY noDecimal.
	^ b
]

{ #category : #examples }
LazyRoassal2 class >> filesystem: path suffix: suffix [
"Visualising the file system"
| allFilesUnderPath b |
allFilesUnderPath := path asFileReference allChildren.
b := RTMondrian new.
b shape circle 
	color: Color gray trans;
	if: [ :aFile | aFile path basename endsWith: suffix ] color: Color red.
b nodes: allFilesUnderPath.
b edges connectFrom: #parent.
b normalizer
	normalizeSize: #size min: 10 max: 100 using: #yourself.
b layout cluster.
^b

]

{ #category : #examples }
LazyRoassal2 class >> multiplot [
	"Multiple graphs"

  <sampleInstance>
	| b colorNormalizer ds |
	b := RTGrapher new.
	colorNormalizer := RTMultiLinearColorForIdentity new
		objects: (1 to: 5).
	1 to: 5 do: [ :i | 
		ds := RTData new
			noDot;
			points: ((1 to: 500) collect: [ :ii | 50 atRandom - 25 ]) cumsum;
			connectColor: (colorNormalizer rtValue: i);
			yourself.
		b add: ds ].
	^ b
]

{ #category : #examples }
LazyRoassal2 class >> numberCluster [
	<sampleInstance>
	| b |
	b := RTMondrian new.
	b shape label.
	b nodes: (1 to: 100).
	b edges connectFrom: [ :i | i // 2 ].
	b layout cluster.
	^ b
]

{ #category : #examples }
LazyRoassal2 class >> openStreetMapBar [
	<sampleInstance>
	| v map paris london newyork data |
	v := RTView new.
	v @ RTDraggableView.
	map := RTOSM new.
	v add: map element.
	paris := 48.8567 @ 2.3508.
	newyork := 40.1727 @ -74.0059.
	london := 51.507222 @ -0.1275.
	data := {{paris.
	#(10 5 10 3 10 6 8)}.
	{london.
	#(5 3 3 -5)}.
	{newyork.
	#(5 -2 10 15 -10)}}.
	data
		do: [ :tuple | 
			| grapher dataSet barElements |
			grapher := RTGrapher new
				extent: 150 @ 100;
				yourself.
			dataSet := RTData new.
			dataSet points: tuple second.
			dataSet barShape
				width: 10;
				color: Color red.
			grapher
				add: dataSet;
				build.
			barElements := grapher view elements.
			v addAll: barElements.
			barElements translateTo: (map latLonToRoassal: tuple first) ].
	v canvas camera
		translateTo: (map latLonToRoassal: paris);
		noInitializationWhenOpen;
		scale: 0.3.
	^ v
]

{ #category : #examples }
LazyRoassal2 class >> openStreetMapPlot [
	"More OpenStreetMap"

	<sampleInstance>
	| v map london data b d elementsAndEdges whiteBackground |
	v := RTView new.
	v @ RTDraggableView.
	map := RTOSM new.
	v add: map element.
	london := 51.507222 @ -0.1275.
	data := ((1 to: 500) collect: [ :i | 50 atRandom - 25 ]) cumsum.
	b := RTGrapher new.
	b extent: 100 @ 30.
	d := RTData new.
	d noDot.
	d connectColor: Color red.
	d points: data.
	b add: d.
	b axisY
		labelFontHeight: 6;
		color: Color red;
		title: 'Sale'.
	b axisX
		color: Color red;
		noTick;
		title: 'country'.
	b build.
	elementsAndEdges := b view elements , b view edges.
	whiteBackground := (RTRoundedBox new
		color: Color white trans;
		borderRadius: 10) element.
	v add: whiteBackground.
	v addAll: elementsAndEdges.
	RTNest new on: whiteBackground nest: elementsAndEdges.
	whiteBackground translateTo: (map latLonToRoassal: london).
	v canvas camera
		translateTo: (map latLonToRoassal: london);
		noInitializationWhenOpen;
		scale: 1.5.
	^ v
]

{ #category : #examples }
LazyRoassal2 class >> timeline [
	<sampleInstance>
	| data b s |
	data := #(#(WP1 0 4) #(WP2 4 8) #(WP3 8 12) #(WP4 3 4) #(WP4 7 9) #(WP4 10 12)).
	b := RTTimeline new.
	s := RTTimelineSet new.
	s objects: data.
	s lineIdentifier: #first.
	s start: #second.
	s end: #third.
	b add: s.
	b axisX
		noDecimal;
		title: 'Month';
		numberOfLabels: 12.
	^ b
]

{ #category : #examples }
LazyRoassal2 class >> usCensus [
	<sampleInstance>
	| tab b |
	tab := RTTabTable new
		input:
			'http://agilevisualization.com/AgileVisualization/census.csv' asUrl
				retrieveContents
		usingDelimiter: $,.
	tab removeFirstRow.
	tab convertColumnsAsInteger: #('POPESTIMATE2013' 'POPEST18PLUS2013').
	b := RTDoubleBarBuilder new.
	b pointName: [ :row | row at: (tab indexOfName: 'NAME') ].
	b points: tab values allButFirst.
	b
		bottomValue:
			[ :row | ((row at: (tab indexOfName: 'POPESTIMATE2013')) / 1000) asInteger ]
		titled: 'Pop estimate (thousands)'.
	b
		topValue:
			[ :row | ((row at: (tab indexOfName: 'POPEST18PLUS2013')) / 1000) asInteger ]
		titled: 'Pop 18+ estimate (thousands)'.
	^ b
]
