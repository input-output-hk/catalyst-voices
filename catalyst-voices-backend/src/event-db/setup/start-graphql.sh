npm install graphile-contrib/pg-simplify-inflector
export DEBUG="graphile-build-pg,postgraphile:postgres*"
npx postgraphile \
    -c 'postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev' \
    -p 5050 \
    --cors \
    --subscriptions \
    --dynamic-json \
    --no-setof-functions-contain-nulls \
    --no-ignore-rbac \
    --show-error-stack=json \
    --extended-errors hint,detail,errcode \
    --append-plugins @graphile-contrib/pg-simplify-inflector \
    --export-schema-graphql schema.graphql \
    --graphiql "/" \
    --enhance-graphiql \
    --allow-explain \
    --enable-query-batching \
    --legacy-relations omit \
    --schema public,private \
    --default-role cat_anon \
    --jwt-secret "CHANGE_ME" \
    --jwt-token-identifier private.jwt_token

