-- Create the namespace in the DB.
-- Template.
CREATE KEYSPACE IF NOT EXISTS {{keyspace}}
    With replication = {'class': 'NetworkTopologyStrategy','replication_factor': 1};