package eu.europeana.commonculture.lod.crawler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.rdf.model.StmtIterator;

import eu.europeana.commonculture.lod.crawler.http.AccessException;
import eu.europeana.commonculture.lod.crawler.rdf.RdfReg;
import eu.europeana.commonculture.lod.crawler.rdf.RdfUtil;


public class DatasetDescription {

	public static List<String> listRootResources(String datasetUri) throws AccessException, InterruptedException, IOException{
		ArrayList<String> uris= new ArrayList<String>();
		Model model = RdfUtil.readRdfFromUri(datasetUri);
		if (model==null ) return uris;
		Resource  dsResource=model.createResource(datasetUri);
		if (dsResource==null ) return uris;
		StmtIterator voidRootResources = dsResource.listProperties(RdfReg.VOID_ROOT_RESOURCE);
		voidRootResources.forEachRemaining(st -> uris.add(st.getObject().asResource().getURI()));
		return uris;
	}
	
}
