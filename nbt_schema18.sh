#!/bin/bash

# 2017-06-13 - RV

n=99


# issue: follows data.kb.nl/resource/{ppn} for resources
#   and data.bibliotheken.nl/id/thes/p{ppn} for thes. resources


## 2017-05-18 RV
# - fixes dc:hasFormat dc:isFormatOf URI's
# - ads schema:about KBCode
# - fixes partOf URI's
# - ads pica:021A/pica:021A9 ?pica021A9 partOf URI
# - delete CreativeWorkds
# - ads links to corp thes (schema:about)
# - ads links to corp. authors (from thes)

## 2017-06-12
# - now uses both isbn13 and isnb10

## 2017-06-13
# - added isPartOf {pica:036F/pica:036F9}

## 2017-06-23
# - added pica:037A/pica:037Aa schema:description
# - added schema:isBasedOn and schema:translationOfWork
# - added schema:isBasedOn for pica:039Q

## TODO
# isPartOf vlgs pica:036B/pica:036B9
# - ad links to corp. authors (unthes.)


## parameters:
#
# output to:
#  <http://data.bibliotheken.nl/nbt-schema/> (http://data.bibliotheken.nl/id/nbt/p{ppn}
#
# input from:
#  <http://data.bibliotheken.nl/nbtraw/>


##
#  Disable checkpoints while running script:
echo 'checkpoint_interval(6000);'

##
#  Core template first:
for seq in `seq -w 0 $n` ; do echo '
ECHO  "Core template {seq}:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:CreativeWork .
	?URI foaf:isPrimaryTopicOf [
		rdf:type foaf:Document ;
		owl:sameAs ?Doc ;
		foaf:primaryTopic ?URI ;
		schema:license <https://opendatacommons.org/licenses/by/1-0/>	;
		void:inDataset <http://data.bibliotheken.nl/id/dataset/nbt> ;
		<http://data.bibliotheken.nl/def#ppn> ?ppn
	] .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/doc/nbt/p", ?ppn)) AS ?Doc )
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
        FILTER REGEX (STR(?ppn), "^.{seq}")

}};
' | perl -pe "s@{seq}@$seq@" ; done

##
#  First author, not from thes.:
for seq in `seq -w 0 $n` ; do echo '
ECHO  "First author, direct {seq}:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:author [
		rdf:type schema:Person ;
		schema:name ?isbdAuthor
	].
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:028A/ev:isbdAuthor ?isbdAuthor .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER NOT EXISTS {?s pica:028A/pica:028A9 ?dummy . }
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
	FILTER REGEX (STR(?ppn), "^.{seq}")
}};
' | perl -pe "s@{seq}@$seq@" ; done

##
#  Second author, not from thes.:
for seq in `seq -w 0 $n` ; do echo '
ECHO  "Second author, direct {seq}:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:contributor [
		rdf:type schema:Person ;
		schema:name ?isbdAuthor
	].
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:028B/ev:isbdAuthor ?isbdAuthor .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER NOT EXISTS {?s pica:028B/pica:028B9 ?dummy . }
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
        FILTER REGEX (STR(?ppn), "^.{seq}")
}};
' | perl -pe "s@{seq}@$seq@" ; done

##
#  Third author, not from thes.:
for seq in `seq -w 0 $n` ; do echo '
ECHO  "Third author, direct {seq}:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:contributor [
		rdf:type schema:Person ;
		schema:name ?isbdAuthor
	].
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:028C/ev:isbdAuthor ?isbdAuthor .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER NOT EXISTS {?s pica:028C/pica:028C9 ?dummy . }
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
	FILTER REGEX (STR(?ppn), "^.{seq}")
}};
' | perl -pe "s@{seq}@$seq@" ; done


##
#  First author, from thes.:
echo '
ECHO  "First author, thes:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:author ?thesAuthor .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:028A/pica:028A9 ?thesAuthor  .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};
'

##
#  Second author, from thes.:
echo '
ECHO  "Second author, thes:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:contributor ?thesAuthor .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:028B/pica:028B9 ?thesAuthor  .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};
'

##
#  Third author, from thes.:
echo '
ECHO  "Third author, thes:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:contributor ?thesAuthor .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:028C/pica:028C9 ?thesAuthor  .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};
'

##
# Corp. authors:
echo '
ECHO "Corporate authors, thes:\n"
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:author ?org1 .
	?URI schema:contributor ?org2 .
	?URI schema:contributor ?org3 .
	?URI schema:contributor ?org4 .
	?URI schema:contributor ?org5 .
	?URI schema:contributor ?org6 .
	?URI schema:contributor ?org7 .
	?URI schema:contributor ?org8 .
	?URI schema:contributor ?org9 .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )

	?s pica:029F ?p27F01 .
	?p27F01 ev:hasOccurrence "01" .
	?p27F01 pica:029F9 ?org1 .
	OPTIONAL {
		?s pica:029F ?p27F02 .
		?p27F02 ev:hasOccurrence "02" .
		?p27F02 pica:029F9 ?org2 .
	}
	OPTIONAL {
		?s pica:029F ?p27F03 .
		?p27F03 ev:hasOccurrence "03" .
		?p27F03 pica:029F9 ?org3 .
	}
	OPTIONAL {
		?s pica:029F ?p27F04 .
		?p27F04 ev:hasOccurrence "04" .
		?p27F04 pica:029F9 ?org4 .
	}
	OPTIONAL {
		?s pica:029F ?p27F05 .
		?p27F05 ev:hasOccurrence "05" .
		?p27F05 pica:029F9 ?org5 .
	}
	OPTIONAL {
		?s pica:029F ?p27F06 .
		?p27F06 ev:hasOccurrence "06" .
		?p27F06 pica:029F9 ?org6 .
	}
	OPTIONAL {
		?s pica:029F ?p27F07 .
		?p27F07 ev:hasOccurrence "07" .
		?p27F07 pica:029F9 ?org7 .
	}
	OPTIONAL {
		?s pica:029F ?p27F08 .
		?p27F08 ev:hasOccurrence "08" .
		?p27F08 pica:029F9 ?org8 .
	}
	OPTIONAL {
		?s pica:029F ?p27F09 .
		?p27F09 ev:hasOccurrence "09" .
		?p27F09 pica:029F9 ?org9 .
	}

}};
'

##
#  Publication event:
for seq in `seq -w 0 $n` ; do echo '
ECHO  "Publication event {seq}:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI schema:publication [
			schema:organizer [
				rdf:type schema:Organization;
				schema:name ?uitgever
			] ;
			schema:location ?plaatsen ;
			schema:startDate ?datumUitgave
	] .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	OPTIONAL { ?s pica:033A/pica:033An ?uitgever }
	OPTIONAL { ?s pica:011-/pica:011-a ?datumUitgave }
	OPTIONAL {
		SELECT ?s (GROUP_CONCAT(distinct ?plaatsUitgave; separator = ", ") AS ?plaatsen)
		WHERE {  ?s pica:033A/pica:033Ap ?plaatsUitgave . }
		GROUP BY ?s
	}
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
	FILTER REGEX (STR(?ppn), "^.{seq}")
}};
' | perl -pe "s@{seq}@$seq@" ; done


##
#  Lump sum data:
### ONE BIG ECHO STATEMENT UNTIL EOF!
echo '
ECHO  "Lump sum data:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
  	?URI rdfs:label ?isbdTitle .
	?URI schema:name ?isbdTitleShort .
  	?URI schema:inLanguage ?taal .
  	?URI schema:isbn ?ISBN10 .
  	?URI schema:isbn ?ISBN13 .
  	?URI schema:description ?description .
  	?URI schema:numberOfPages ?extent .
  	?URI schema:associatedMedia ?link .
  	?URI schema:about ?thesaurusURI .
  	?URI schema:about ?kbcode .
  	?URI owl:sameAs ?oclcURI .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
  	?s pica:003-/pica:003-0 ?ppn .
  	OPTIONAL { ?s pica:021A/ev:isbdTitle ?isbdTitle  .
    		BIND( fn:substring-before(concat(?isbdTitle, " / "), " / ")  AS ?isbdTitleShort )
  	}
  	OPTIONAL { ?s pica:010-/pica:010-a ?taal }
  	OPTIONAL { ?s pica:004A/pica:004A0 ?ISBN10 }
  	OPTIONAL { ?s pica:004A/pica:004AA ?ISBN13 }
  	OPTIONAL { ?s pica:020A/pica:020Aa ?description }
  	OPTIONAL { ?s pica:037E/pica:037Ea ?description }
	OPTIONAL { ?s pica:037A/pica:037Aa ?description }
  	OPTIONAL { ?s pica:034D/pica:034Da ?extent }
    	OPTIONAL {
		?s pica:009P/pica:009Pa ?page
		BIND(IRI(?page) as ?link)
	}
	OPTIONAL { ?s pica:044Z/pica:044Z9 ?thesaurusURI }
  	OPTIONAL { ?s pica:045T/pica:045T9 ?thesaurusURI }
  	OPTIONAL { ?s pica:045S/pica:045Sa ?thesaurusURI }
  	OPTIONAL { ?s pica:045R/pica:045R9 ?thesaurusURI }
  	OPTIONAL { ?s pica:045Q/pica:045Q9 ?thesaurusURI }
  	OPTIONAL { ?s pica:044K/pica:044K9 ?thesaurusURI }
  	OPTIONAL { ?s pica:040-/pica:040-9 ?thesaurusURI }
  	OPTIONAL { ?s pica:041-/pica:041-9 ?thesaurusURI }
  	OPTIONAL { ?s ev:hasLocalBlock/pica:145Z/pica:145Z9 ?kbcode }
	OPTIONAL { ?s pica:003O/pica:003O0 ?OCLCnummer
	     BIND(IRI(CONCAT("http://www.worldcat.org/oclc/", ?OCLCnummer)) as ?oclcURI)
	}
  	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
  	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};

# fixed partOf URIs
ECHO  "PartOf URIs:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
  	?URI schema:isPartOf ?URI036D9 .
  	?URI schema:isPartOf ?URI036E9 .
	?URI schema:isPartOf ?URI036F9 .
  	?URI schema:isPartOf ?URI021A9 .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
  	?s pica:003-/pica:003-0 ?ppn .
  	OPTIONAL {
		# KMC 4160 PPN-verwijzing naar titel van (sub)koepel van meerdelige publicatie in gestandaardiseerde vorm
  		?s pica:036D/pica:036D9 ?pica036D9 .
  		BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", fn:substring-after(str(?pica036D9), "http://data.kb.nl/resource/"))) AS ?URI036D9)
  	}
    	OPTIONAL {
		# KMC 417X Titel van koepel van reeks zoals vermeld in publicatie
    		?s pica:036E/pica:036E9 ?pica036E9 .
    		BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", fn:substring-after(str(?pica036E9), "http://data.kb.nl/resource/"))) AS ?URI036E9)
    	}
	OPTIONAL {
		# KMC 418X PPN-verwijzing naar titel van koepel van reeks in gestandaardiseerde vorm
		 ?s pica:036F/pica:036F9 ?pica036F9 .
                BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", fn:substring-after(str(?pica036F9), "http://data.kb.nl/resource/"))) AS ?URI036F9)
	}
    	OPTIONAL {
		# KMC 4000  - snap dit niet helemaal RV
    		?s pica:021A/pica:021A9 ?pica021A9 .
    		BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", fn:substring-after(str(?pica021A9), "http://data.kb.nl/resource/"))) AS ?URI021A9)
    	}
  	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
  	FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};

##
#  Extra for all A-things:
ECHO  "A-things:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI dcterms:hasFormat ?URIrel .
}
WHERE  { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:039T/pica:039T9 ?relation .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND (fn:substring-after(str(?relation), "http://data.kb.nl/resource/") AS ?ppnrel)
    BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppnrel)) AS ?URIrel)
  	FILTER REGEX (?type, "(^A)")
}};

##
#  Extra for all O-things:
ECHO  "O-things:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI dcterms:isFormatOf ?URIrel .
}
WHERE  { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	?s pica:039T/pica:039T9 ?relation .
  	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND (fn:substring-after(str(?relation), "http://data.kb.nl/resource/") AS ?ppnrel)
    BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppnrel)) AS ?URIrel)
  	FILTER REGEX (?type, "(^O)")
}};

##
#  Extra for A-books:
ECHO  "A-books:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Book .
	?URI schema:bookFormat <http://bibliograph.net/PrintBook> .
	?URI schema:bookEdition ?editie .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
  	OPTIONAL { ?s pica:032-/pica:032-a ?editie } .
  	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
  	BIND(fn:substring(?type,1,2) as ?firstChar)
  	FILTER REGEX (?firstChar, "(Aa|Ae|AF)", "i")
}};

##
#  Extra for O-books:
ECHO  "O-books:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:EBook .
	?URI schema:bookEdition ?editie .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
   	OPTIONAL { ?s pica:032-/pica:032-a ?editie } .
   	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   	BIND(fn:substring(?type,1,2) as ?firstChar)
   	FILTER REGEX (?firstChar, "(Oa|Oe)", "i")
}};

##
#  Extra for A-periodicals (tijdschr., krant of koepel seriele publ.):
ECHO  "A-periodicals:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Periodical .
	?URI schema:issn ?ISSN .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
   	?s pica:002-/pica:002-0 ?type .
   	?s pica:003-/pica:003-0 ?ppn .
   	OPTIONAL { ?s pica:005A/pica:005A0 ?ISSN }
   	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   	BIND(fn:substring(?type,1,2) as ?firstChar)
   	FILTER REGEX (?firstChar, "Ab")
}};

##
#  Extra for O-periodicals (tijdschr., krant of koepel seriele publ.):
ECHO  "O-periodicals:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Periodical .
	?URI schema:issn ?ISSN .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	OPTIONAL { ?s pica:005A/pica:005A0 ?ISSN }
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   	BIND(fn:substring(?type,1,2) as ?firstChar)
   	FILTER REGEX (?firstChar, "Ob")
}};

##
#  Extra for A-multivolumeBook (koepeltitel):
ECHO  "A-multivol books:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:BookSeries .
	?URI schema:bookFormat <http://bibliograph.net/PrintBook> .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
   	?s pica:002-/pica:002-0 ?type .
   	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Ac")
}};

##
#  Extra for O-multivolumeBook (koepeltitel):
ECHO  "O-mutivol books:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:BookSeries .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Oc")
}};

##
#  Extra for A-articles:
ECHO  "A-articles:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Article .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "As")
}};

##
#  Extra for O-articles:
ECHO  "O-articles:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
   ?URI rdf:type schema:Article .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
   ?s pica:002-/pica:002-0 ?type .
   ?s pica:003-/pica:003-0 ?ppn .
   BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   BIND(fn:substring(?type,1,2) as ?firstChar)
   FILTER REGEX (?firstChar, "Of", "i")
}};

##
#  Extra for manuscripts:
ECHO  "Manuscripts:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type <http://purl.org/ontology/bibo/Manuscript> .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "(Fa|FF)", "i")
}};

##
#  Extra for multivolume manuscripts:
ECHO  "Multivol manuscripts:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type <http://purl.org/ontology/bibo/Manuscript> .
	?URI rdf:type schema:BookSeries .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Fc")
}};


##
#  Extra for sheet music:
ECHO  "Sheet music:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:MusicComposition .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "(Ma|MF|Me|Mf)", "i")
}};

##
#  Extra for multivolume sheet music:
ECHO  "Multivol. sheet music:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:MusicComposition .
	?URI rdf:type schema:BookSeries .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Mc")
}};

##
#  Extra for periodical sheet music:
ECHO  "Periodical sheet music:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:MusicComposition .
	?URI rdf:type schema:Periodical .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Mb")
}};

##
#  Extra for maps:
ECHO  "Maps:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Map .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
   	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   	BIND(fn:substring(?type,1,2) as ?firstChar)
   	FILTER REGEX (?firstChar, "(Ka|KF|Ke)", "i")
}};

##
#  Extra for multivolume maps:
ECHO  "Multivol maps:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Map .
	?URI rdf:type schema:BookSeries .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Kc")
}};

##
#  Extra for periodical maps:
ECHO  "Periodical maps:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:Map .
	?URI rdf:type schema:Periodical .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Kb")
}};

##
#  Extra for illustrations:
ECHO  "Illustrations:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:VisualArtwork .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   	BIND(fn:substring(?type,1,2) as ?firstChar)
   	FILTER REGEX (?firstChar, "(Ia|IF|If)", "i")
}};

##
#  Extra for multivolume illustrations:
ECHO  "Multivol illustrations:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:VisualArtwork .
	?URI rdf:type schema:BookSeries .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
	?s pica:002-/pica:002-0 ?type .
	?s pica:003-/pica:003-0 ?ppn .
	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
	BIND(fn:substring(?type,1,2) as ?firstChar)
	FILTER REGEX (?firstChar, "Ic")
}};

##
#  Extra for software:
ECHO  "Software:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?URI rdf:type schema:SoftwareApplication .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
   	?s pica:002-/pica:002-0 ?type .
   	?s pica:003-/pica:003-0 ?ppn .
   	BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
   	FILTER REGEX (?type, "(^S)")
}};

# add doc uris to dataset:
ECHO  "Add doc URIs to dataset:\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
	?o void:inDataset <http://data.bibliotheken.nl/id/dataset/nbt> .
}
WHERE {  GRAPH <http://data.bibliotheken.nl/nbt-schema/> {
	?s foaf:isPrimaryTopicOf ?bn .
	?bn void:inDataset <http://data.bibliotheken.nl/id/dataset/nbt> .
	?bn owl:sameAs ?o .
}};
'

n=9
for seq in `seq -w 0 $n` ; do echo '
ECHO "Delete CreativeWork {seq}\n:";
SPARQL
DEFINE sql:log-enable 3
DELETE {
	?s rdf:type schema:CreativeWork .
}
FROM <http://data.bibliotheken.nl/nbt-schema/>
WHERE { GRAPH <http://data.bibliotheken.nl/nbt-schema/> {
	?s rdf:type schema:CreativeWork .
	BIND (fn:substring-after(str(?s), "http://data.bibliotheken.nl/id/nbt/p") AS ?ppn)
	FILTER REGEX (STR(?ppn), "^.{seq}")
}};
' | perl -pe "s@{seq}@$seq@" ; done


echo '
ECHO  "Translation of (where 'Oorspr. titel' exists):\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
        ?URI schema:translationOfWork [
        		rdf:type schema:CreativeWork ;
                rdfs:label ?translation 
        ] .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
        ?s pica:002-/pica:002-0 ?type .
        ?s pica:003-/pica:003-0 ?ppn .
        ?s pica:039D ?pica39D .
		?pica39D pica:039Da "Oorspr. titel" .
		?pica39D pica:039Dc ?translation .
        BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
        FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};
ECHO  "Based on of (where 'Oorspr. titel' exists):\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
        ?URI schema:isBasedOn [
                rdfs:label ?based 
        ] .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
        ?s pica:002-/pica:002-0 ?type .
        ?s pica:003-/pica:003-0 ?ppn .
		?s pica:039D/pica:039Da "Oorspr. titel" .
		?s pica:039D/pica:039Da "Vert. van" .
		?s pica:039D ?pica39D .
		?pica39D pica:039Da "Vert. van" .
		?pica39D pica:039Dc ?based .
        BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
        FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};
ECHO  "Translation of (where no 'Oorspr. titel' exists):\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
        ?URI schema:translationOfWork [
        		rdf:type schema:CreativeWork ;
                rdfs:label ?translation 
        ] .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
        ?s pica:002-/pica:002-0 ?type .
        ?s pica:003-/pica:003-0 ?ppn .
        ?s pica:039D ?pica39D .
		?pica39D pica:039Da "Vert. van" .
		?pica39D pica:039Dc ?translation .
        BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
        FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
        MINUS { ?s pica:039D/pica:039Da "Oorspr. titel" . }
}};


ECHO  "schema:isBasedOn (pica:039Q):\n";
SPARQL
DEFINE sql:log-enable 3
INSERT INTO GRAPH <http://data.bibliotheken.nl/nbt-schema/>
{
        ?URI schema:isBasedOn ?basedUri .
}
WHERE { GRAPH <http://data.bibliotheken.nl/nbtraw/> {
        ?s pica:002-/pica:002-0 ?type .
        ?s pica:003-/pica:003-0 ?ppn .
        ?s pica:039Q/pica:039Q9 ?based .
        BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", fn:substring-after(str(?based), "http://data.kb.nl/resource/"))) AS ?basedUri)
        BIND(IRI(CONCAT("http://data.bibliotheken.nl/id/nbt/p", ?ppn)) AS ?URI )
        FILTER REGEX (?type, "(^A|^O|^F|^M|^K|^I|^S)")
}};

'

##
#  Re-enable checkpoints
echo 'checkpoint_interval(120);'
