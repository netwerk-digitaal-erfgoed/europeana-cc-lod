package eu.europeana.commonculture.lod.crawler;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;

import com.ontologycentral.ldspider.Crawler;

import eu.europeana.commonculture.lod.crawler.http.AccessException;

public class CommandLineInterface {

//CommandLineInterface --dataset_uri http://data.bibliotheken.nl/id/dataset/rise-centsprenten --output_file ./data/crawled/rise-centsprenten.nt
	public static void main(String[] args) {
		CommandLineParser parser = new DefaultParser();

		// create the Options
		Options options = new Options();
		options.addOption( "dataset_uri", true, "URI of dataset to crawl.");
		options.addOption( "output_file", true, "Path to the output file.");
		options.addOption( "max_depth", true, "Set a limit for the crawling depth. Default is 0.");
		options.addOption( "log_file", true, "Write a log with the result of the crawl. If ommited no log is created.");
		
		CommandLine line=null;
		
		boolean argsOk=true;
		try {
		    line = parser.parse( options, args );
		    if( !line.hasOption("dataset_uri") || !line.hasOption("output_file") ) 
		    	argsOk=false;
		    else try {
		    	Integer.parseInt(line.getOptionValue("max_depth", "0"));
		    } catch (NumberFormatException e1) {
		    	argsOk=false;
		    } 
		} catch( ParseException exp ) {
			argsOk=false;
		}
	    String result=null;
	    String logFilePath=null;
	    if(argsOk) {
	    	logFilePath = line.getOptionValue("log_file");
	    	String dsUri = line.getOptionValue("dataset_uri");
	    	String outFile = line.getOptionValue("output_file");
	    	LinkedDataCrawler crawler=new LinkedDataCrawler(dsUri, Integer.parseInt(line.getOptionValue("max_depth", "0")), -1); 
			try {
				int seeds=crawler.crawl(new File(outFile));
				if(seeds==0)
					result="FAILURE\nNo URI seeds found";
				else
					result="SUCCESS";
			} catch (IOException | AccessException | InterruptedException e) {
				result="FAILURE\nstackTrace:\n"+ExceptionUtils.getStackTrace(e);
			}
	    } else {
	    	StringWriter sw=new StringWriter();
	    	PrintWriter w=new PrintWriter(sw);
	    	HelpFormatter formatter = new HelpFormatter();
	    	formatter.printUsage( w, 120, "crawler.sh", options );
	    	w.close();
	    	result="INVALID PARAMETERS\n"+sw.toString();
	    }
	    System.out.println(result);
	    if(logFilePath!=null) {
	    	try {
				File logFile = new File(logFilePath);
				if(logFile.getParentFile()!=null && !logFile.getParentFile().exists())
					logFile.getParentFile().mkdirs();
				FileUtils.write(logFile, result, "UTF-8");
			} catch (IOException e) {
				System.out.println("Warning: Unable to write to log file\nStackTrace:\n"+ExceptionUtils.getStackTrace(e));
			}
	    }
	}
}
