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
	String datasetUri;
	Model model;
	
	public DatasetDescription(String datasetUri) throws AccessException, InterruptedException, IOException {
		this.datasetUri = datasetUri;
		model = RdfUtil.readRdfFromUri(datasetUri);
	}

	public List<String> listRootResources() throws AccessException, InterruptedException, IOException{
		ArrayList<String> uris= new ArrayList<String>();
		Resource  dsResource=model.createResource(datasetUri);
		if (dsResource==null ) return uris;
		StmtIterator voidRootResources = dsResource.listProperties(RdfReg.VOID_ROOT_RESOURCE);
		voidRootResources.forEachRemaining(st -> uris.add(st.getObject().asResource().getURI()));
		return uris;
	}
	
}
