-- Create the namespace in the DB.
-- Template.
CREATE KEYSPACE IF NOT EXISTS {{keyspace}} WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '{{region1}}' : {{replication_factor}}, '{{region2}}' : {{replication_factor}} };



