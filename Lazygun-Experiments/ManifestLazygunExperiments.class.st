"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestLazygunExperiments,
	#superclass : #PackageManifest,
	#category : #'Lazygun-Experiments-Manifest'
}

{ #category : #'code-critics' }
ManifestLazygunExperiments class >> ruleRBImplementedNotSentRuleV1FalsePositive [
	^ #(#(#(#RGMetaclassDefinition #(#'LazyRoassal2 class' #LazyRoassal2)) #'2020-05-08T16:13:36.7985+01:00') )
]

{ #category : #'code-critics' }
ManifestLazygunExperiments class >> ruleRBKeysDoRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'LazyRoassal2 class' #earthquakeMap #true)) #'2020-05-08T16:13:02.681608+01:00') )
]

{ #category : #'code-critics' }
ManifestLazygunExperiments class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'LazyRoassal2 class' #ebolaPlot #true)) #'2020-05-08T16:16:44.084652+01:00') #(#(#RGMetaclassDefinition #(#'LazyRoassal2 class' #LazyRoassal2)) #'2020-05-08T16:24:47.136423+01:00') )
]

{ #category : #'code-critics' }
ManifestLazygunExperiments class >> ruleRTInvocationSequenceRuleV1FalsePositive [
	^ #(#(#(#RGMetaclassDefinition #(#'LazyRoassal2 class' #LazyRoassal2)) #'2020-05-08T16:13:13.204977+01:00') )
]
