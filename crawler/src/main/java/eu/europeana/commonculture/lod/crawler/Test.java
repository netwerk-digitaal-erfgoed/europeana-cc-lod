package eu.europeana.commonculture.lod.crawler;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.RDFNode;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.rdf.model.Statement;
import org.apache.jena.rdf.model.StmtIterator;
import org.apache.jena.riot.Lang;
import org.semanticweb.yars.util.CallbackNxBufferedWriter;

import com.ontologycentral.ldspider.Crawler;
import com.ontologycentral.ldspider.CrawlerConstants;
import com.ontologycentral.ldspider.frontier.BasicFrontier;
import com.ontologycentral.ldspider.frontier.Frontier;
import com.ontologycentral.ldspider.hooks.content.ContentHandler;
import com.ontologycentral.ldspider.hooks.content.ContentHandlerNx;
import com.ontologycentral.ldspider.hooks.content.ContentHandlerRdfXml;
import com.ontologycentral.ldspider.hooks.content.ContentHandlers;
import com.ontologycentral.ldspider.hooks.links.LinkFilter;
import com.ontologycentral.ldspider.hooks.links.LinkFilterDomain;
import com.ontologycentral.ldspider.hooks.sink.Sink;
import com.ontologycentral.ldspider.hooks.sink.SinkCallback;
import com.ontologycentral.ldspider.queue.HashTableRedirects;
import com.ontologycentral.ldspider.seen.HashSetSeen;
import com.ontologycentral.ldspider.seen.Seen;

import eu.europeana.commonculture.lod.crawler.http.AccessException;
import eu.europeana.commonculture.lod.crawler.http.HttpRequestService;
import eu.europeana.commonculture.lod.crawler.rdf.CallbackNtriplesBufferedWriterJena;
import eu.europeana.commonculture.lod.crawler.rdf.CallbackTriplesQuadsBufferedWriter;
import eu.europeana.commonculture.lod.crawler.rdf.RdfReg;
import eu.europeana.commonculture.lod.crawler.rdf.RdfUtil;

public class Test {
	public static void main(String[] args) {
		try {
			String uri = "http://data.bibliotheken.nl/id/dataset/rise-centsprenten";
			Model datasetDescModel = RdfUtil.readRdfFromUri(uri);
			Resource  datasetDescResource = datasetDescModel.getResource(uri);
			
			//		configure crawler with the URIs from jena model
			int totalSeeds=0;
			Crawler crawler = new Crawler(5);
//			Crawler crawler = new Crawler(CrawlerConstants.DEFAULT_NB_THREADS);
			Frontier frontier=new BasicFrontier();
			StmtIterator voidRootResources = datasetDescResource.listProperties(RdfReg.VOID_ROOT_RESOURCE);
			if (voidRootResources!=null && voidRootResources.hasNext()) {
				for( ; voidRootResources.hasNext(); ) {
					Statement st=voidRootResources.next();
					frontier.add(new URI(st.getObject().asNode().getURI().toString()));
					totalSeeds++;
					
					if(totalSeeds>=3)
						break;
				}
			} else { //try a Distribution of the dataset
				throw new RuntimeException("TODO");
			}
			
			ContentHandler contentHandler = new ContentHandlers(new ContentHandlerRdfXml(), new ContentHandlerNx());
			crawler.setContentHandler(contentHandler);
			FileWriter out=new FileWriter(new File("target/centsprenten.nt"));
			BufferedWriter out2 = new BufferedWriter(out);
			CallbackTriplesQuadsBufferedWriter writer=new CallbackTriplesQuadsBufferedWriter(out2, false, Lang.NTRIPLES);
//			CallbackNtriplesBufferedWriter writer=new CallbackNtriplesBufferedWriter(out2, false);
			Sink sink = new SinkCallback(writer, false);
			crawler.setOutputCallback(sink);		
			LinkFilterDomain linkFilter = new LinkFilterDomain(frontier);  
			linkFilter.addHost("http://data.bibliotheken.nl/");  
			crawler.setLinkFilter(linkFilter);
			
			//		crawl and dum to n-triples
			int depth = 0;
			int maxURIs = totalSeeds*20;
			
			crawler.evaluateBreadthFirst(frontier, new HashSetSeen(), new HashTableRedirects(), depth, maxURIs, -1, -1, false);
			out2.flush();
			out.close();
			HttpRequestService.INSTANCE.close();
			crawler.close();
		} catch (AccessException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
