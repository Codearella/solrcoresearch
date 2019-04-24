# SolrCoreSearch
This is an ASP.NET Core MVC search web app that uses a Apache Solr (Lucene) server for the backend.

## Prerequisites

1. Windows 10 *(Other versions may also work but have not been tested.)*
2. Java 8 or later *(Verify using **java -version** from the command prompt. You may also need to configure your PATH system variable under System Properties > Environment Variables.)*         	
3. curl version 7.55.1 or later
4. solr-8.0.0 *(For Windows, use the solr-8.0.0.zip version of the file.)*
      http://lucene.apache.org/solr/downloads.html
     

## Install the Solr server on a Windows device

1. In command prompt, navigate to the directory with the unzipped solr-8.0.0 files (e.g. C:\solr-8.0.0). 
2. If not already started, start the Solr server in cloud mode. If your Solr server is already running, jump ahead to ['Configure the Movies collection on the Solr server'](#configure-the-movies-collection-on-the-solr-server).
~~~~
C:\solr-8.0.0>bin\solr.cmd start -e cloud  
Welcome to the SolrCloud example!

This interactive session will help you launch a SolrCloud cluster on your local workstation.
To begin, how many Solr nodes would you like to run in your local cluster? (specify 1-4 nodes) [2]:
~~~~
3. Press **enter** to accept the default number of nodes (2). 
~~~~
Ok, let's start up 2 Solr nodes for your example SolrCloud cluster.
Please enter the port for node1 [8983]:
~~~~
4. Press **enter** to accept the default port (8983).
~~~~
Please enter the port for node2 [7574]:
~~~~
5. Press **enter** to accept the default port (7574).
6. :coffee: Wait while Solr starts up each node.
~~~~
Please provide a name for your new collection: [gettingstarted]
~~~~
7. Press **enter** to accept the default collection name (gettingstarted).
~~~~
How many shards would you like to split gettingstarted into? [2]
~~~~
8. Press **enter** to accept the default (2 shards).
~~~~
How many replicas per shard would you like to create? [2]
~~~~
9. Press **enter** to accept the default (2 replicas per shard).
10. :coffee: Wait for the setup to complete. 
11. When complete, open http://localhost:8983/solr/#/ in your browser and verify that the Solr dashboard appears.

## Configure the Movies collection on the Solr server

1. Copy the 'movies' folder from the GitHub repo into the 'solr-8.0.0\example\' folder (e.g. C:\solr-8.0.0\example\movies). The movies folder should contain the following files:
~~~~
SetupMovies.bat
movies.csv
DeleteMovies.bat
~~~~
**Important: The movies folder must be located in the \solr-8.0.0\example\ subfolder, or the batch file will not work correctly.**

2. Double-click on SetupMovies.bat. This will create a new collection, configure fields, and index in the data from the movies.csv file.
3. To verify that the data was successfully processed, open http://localhost:8983/solr/#/movies/query and press the 'Execute Query' button. JSON records should be returned and the numFound value should indicate that 45403 records were found.

## Run the SolrCoreSearch web app

1. Clone the project from the GitHub repository. 
2. Open SolrCoreSearch.sln
3. Install dependencies using nuget. 
4. Compile and run the app.
5. Now you're ready to search!

## Post-mortem

After my initial review of the project objectives, it seemed like the tasks were pretty straightforward:

1. Learn how Solr works.
2. Find a good data set.
3. Write a simple web UI that forwards search queries to Solr.
4. Add advanced features.

After going through a couple Solr tutorials, everything seemed pretty easy.  While I’ve never used Lucene before, it’s reputation of being a PITA proceeded it.  I was happy to see that Solr must have sanitized the worst parts of using Lucene.

Now, with Solr running in all of its Java glory, I proceeded to look for a good data set.  That shouldn’t be too tough.  All I want is a data set that is:

* Topically Interesting
* Links that actually go somewhere (after people search, they want a link!)
* Meaty amounts of text – strings less than 140 characters just aren’t all that interesting
* Several thousands of records

Fun fact: well-manicured data sets that meet the above criteria (that you can easily download) are few and far between. After swiping left on a bunch of terrible data sets, I found a pretty sweet IMDB export.  Just a little bit of regex, filtering, and deduplicating and it cleaned up pretty well! 

Solr ingested the data without much complaint, and everything appeared to be sort-of working.  Unfortunately, I learned that when Solr ingests content with automatic field detection, everything is an array of strings.  That, unfortunately makes the dataset frustrating to work with downstream.  As a result, I had the opportunity to learn about Solr schemas.  I learned how you’re not supposed to edit XML files anymore (thanks, old documentation) and instead you’re supposed to tweak everything with a long REST call to the Schema API.  It builds character.

Realizing what this would mean means for the deployment procedure, I set about making a script to manually define the schema fields with the correct data types for everything before importing the data set.

Well, that took more time than I expected. 

On to the web stuff!

John Carmack tweeted something a couple years ago that describes SolrNet perfectly:

*“Abstraction trades an increase in real complexity for a decrease in perceived complexity. That isn't always a win.”*

Instead, my little search ActionResult will be powered by HttpClient!  It doesn’t make my brain hurt, and it’s probably 100x faster because it doesn’t need to deserialize/reserialize any of the data passing through.

It wasn’t long before a Bootstrap-styled search front-end was kicking butt and taking strings.  All the mandatory features were done.  But as time was running low, I decided to pivot towards writing and testing the setup instructions.

Regretfully, there was some low hanging “advanced” fruit left on the tree. For faceting, the eventual plan was to issue two searches (one to get the genre hit counts, and one to fetch the actual search results), and to list the top genres as clickable buttons at the top of the search query to give you a one-click filter. However, I didn't have a chance to finish this.

***Update 2019-04-24:*** I added in the autocomplete functionality using Solr's Suggester features. This was a bit frustrating to set up; Solr warns against editing the XML config file, yet most of the examples for the suggester tell you use this legacy method to edit the config. Also, the Solr 8.0.0. manual is still in draft mode, so not much help there. At any rate, I didn't want to make it hard for the end user to set things up, so I knew I had to do this with CURL in the batch file. After a bit of trial and error, I managed to cobble together the correct commands to update the Solr Suggester config using JSON and Curl. In addition to the updated *SetupMovies.bat* file, I added a *DeleteMovies.bat* file to quickly wipe out the existing Movies collection and associated config. 









