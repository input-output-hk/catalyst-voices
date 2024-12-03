-- Check aws tables status
-- Template.
SELECT status FROM system_schema_mcs.tables WHERE keyspace_name = '{{keyspace_name}}' AND table_name = '{{table_name}}';