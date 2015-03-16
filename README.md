# europeana-test-env

Build a fully functional [Vagrant](https://www.vagrantup.com/) test environment for the Europeana [Portal](https://github.com/europeana/portal)/[API](https://github.com/europeana/api2).

### Services
* [MongoDB](http://www.mongodb.org/) document database, with content (accessible via port 27027) 
* [PostgreSQL](http://www.postgresql.org/) relational database, with content (accessible via port 15432)
* [Neo4j](http://neo4j.com/) graph database, with content (accessible via port 17474)
* [Apache Solr](http://lucene.apache.org/solr/) search engine, with content (accessible via port 18983)

### Software
*  Java 7, required for Solr

##To do
* Finalise Neo4j
* Finalise Solr
* Install [Apache Tomcat](http://tomcat.apache.org/) web server, required for the API
* Install [Europeana API](https://github.com/europeana/api2)
* Add content for
** MongoDB
** Neo4j
** Solr 
