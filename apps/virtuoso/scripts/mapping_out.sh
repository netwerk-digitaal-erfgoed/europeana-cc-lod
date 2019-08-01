isql 1111 -u dba exec='
SPARQL
PREFIX schema:  <http://schema.org/>
PREFIX rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:    <http://www.w3.org/2000/01/rdf-schema#>
PREFIX bib:     <http://bib.schema.org/>
PREFIX edm:     <http://www.europeana.eu/schemas/edm/>
PREFIX dc:      <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/> 
INSERT INTO GRAPH <http://data.bibliotheken.nl/centsprenten_edm/>
{
    ?uri a edm:ProvidedCHO ;
         dc:creator ?author ;
         dc:contributor ?illustrator ;
         dc:publisher ?publisher ;
         dc:title ?name ;
         dc:coverage ?about ;
         dc:description ?description ;
         dcterms:created ?created ;
         dcterms:extent ?width ;
         dcterms:extent ?height ;
         edm:preview ?thumb ;
         edm:isShownBy ?image ;
         edm:isShownAt ?url ;
         dcterms:isPartOf ?isPartOf ;
         dc:rights ?license ;
         edm:currentLocation ?spatial .        
}
WHERE { 
  GRAPH <http://data.bibliotheken.nl/centsprenten/> {
	?uri a ?type .
    OPTIONAL { 
      ?uri bib:author ?l_author .
    }
    OPTIONAL {
      ?uri schema:author ?l_author .
    }
    OPTIONAL {
      ?uri schema:author ?l_author .
    }
    BIND( IF(isLiteral(?l_author),concat(?l_author,""@nl),?l_author) as ?author)

    OPTIONAL { 
      ?uri schema:illustrator ?l_ill .
      BIND( IF(isLiteral(?l_ill),concat(?l_ill,""@nl),?l_ill) as ?illustrator)
    }

    OPTIONAL { 
      ?uri schema:publisher ?l_publisher .
      BIND( IF(isLiteral(?l_publisher),concat(?l_publisher,""@nl),?l_publisher) as ?publisher)
    }
    OPTIONAL { 
      ?uri schema:name ?l_name .
      BIND( IF(isLiteral(?l_name),concat(?l_name,""@nl),?l_name) as ?name)
    }
    OPTIONAL { 
      ?uri schema:about ?l_about .
      BIND( IF(isLiteral(?l_about),concat(?l_about,""@nl),?l_about) as ?about)
    }
    OPTIONAL { 
      ?uri schema:description ?l_desc 
      BIND( IF(isLiteral(?l_desc),concat(?l_desc,""@nl),?l_desc) as ?description)
    }
    OPTIONAL { 
      ?uri schema:dateCreated ?l_created 
      BIND( IF(isLiteral(?l_created),concat(?l_created,""@nl),?l_created) as ?created)
    }

    OPTIONAL { 
      ?uri schema:spatialCoverage ?l_spatial 
      BIND( IF(isLiteral(?l_spatial),concat(?l_spatial,""@nl),?l_spatial) as ?spatial)
    }

    OPTIONAL { 
      ?uri schema:width ?l_width 
      BIND( IF(isLiteral(?l_width),concat("width: ",?l_width),?l_width) as ?width)
    }
    OPTIONAL { 
      ?uri schema:height ?l_height 
      BIND( IF(isLiteral(?l_height),concat("height: ",?l_height),?l_height) as ?height)
    }
    OPTIONAL { 
      ?uri schema:thumbnailUrl ?l_thumb
      BIND( IRI(replace(str(?l_thumb),"role=image&size=variable","role=thumbnail")) as ?thumb )
    }
    OPTIONAL { ?uri schema:image ?image }
    OPTIONAL { ?uri schema:url ?url }
    OPTIONAL { 
      ?uri schema:isPartOf ?l_isPartOf 
      BIND( IF(isLiteral(?l_isPartOf),concat(?l_isPartOf,""@nl),?l_isPartOf) as ?isPartOf)
    }
    OPTIONAL { ?uri schema:license ?license }

  }
}'

