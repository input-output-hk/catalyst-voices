-- Catalyst Event Database

-- objective types table - Defines all currently known objectives types.
CREATE TABLE objective_category
(
    name TEXT PRIMARY KEY,
    description TEXT
);

COMMENT ON TABLE objective_category IS 'Defines all known and valid objective categories.';
COMMENT ON COLUMN objective_category.name IS 'The name of this objective category.';
COMMENT ON COLUMN objective_category.description IS 'A Description of this kind of objective category.';

-- Define known objective categories
INSERT INTO objective_category (name,  description)
VALUES
    ('catalyst-simple','A Simple choice'),
    ('catalyst-native','??'),
    ('catalyst-community-choice','Community collective decision'),
    ('sve-decision','Special voting event decision');

-- known currencies - Defines all currently known currencies.
CREATE TABLE currency
(
    name TEXT PRIMARY KEY,
    description TEXT
);

COMMENT ON TABLE currency IS 'Defines all known and valid currencies.';
COMMENT ON COLUMN currency.name IS 'The name of this currency type.';
COMMENT ON COLUMN currency.description IS 'A Description of this kind of currency type.';


-- Define known currencies
INSERT INTO currency (name,  description)
VALUES
    ('USD_ADA','US Dollars, converted to Cardano ADA at time of reward calculation.'),
    ('ADA','Cardano ADA.'),
    ('CLAP', 'CLAP tokens.'),
    ('COTI', 'COTI tokens.');

-- known vote options - Defines all currently known vote options.
CREATE TABLE vote_options
(
    id SERIAL PRIMARY KEY,

    idea_scale TEXT ARRAY UNIQUE,
    objective TEXT ARRAY UNIQUE
);

COMMENT ON TABLE vote_options IS 'Defines all known vote plan option types.';
COMMENT ON COLUMN vote_options.id IS 'Unique ID for each possible option set.';
COMMENT ON COLUMN vote_options.idea_scale IS 'How this vote option is represented in idea scale.';
COMMENT ON COLUMN vote_options.objective IS 'How the vote options is represented in the objective.';

-- Define known vote_options
INSERT INTO vote_options (idea_scale,  objective)
VALUES
    ('{"blank", "yes", "no"}','{"yes", "no"}');



-- goals

CREATE TABLE goal
(
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,

    idx INTEGER NOT NULL,
    name VARCHAR NOT NULL,

    FOREIGN KEY(event_id) REFERENCES event(row_id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX goal_index ON goal(event_id, idx);

COMMENT ON TABLE goal IS 'The list of campaign goals for this event.';
COMMENT ON COLUMN goal.id IS 'Synthetic Unique Key.';
COMMENT ON COLUMN goal.idx IS 'The index specifying the order/priority of the goals.';
COMMENT ON COLUMN goal.name IS 'The description of this event goal.';
COMMENT ON COLUMN goal.event_id IS 'The ID of the event this goal belongs to.';
COMMENT ON INDEX goal_index IS 'An index to enforce uniqueness of the relative `idx` field per event.';


-- objective table - Defines all objectives for all known funds.


CREATE TABLE objective
(
    row_id SERIAL PRIMARY KEY,

    id INTEGER NOT NULL,
    event INTEGER NOT NULL,

    category TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,

    deleted BOOLEAN NOT NULL DEFAULT FALSE,

    rewards_currency TEXT,
    rewards_total BIGINT,
    rewards_total_lovelace BIGINT,
    proposers_rewards BIGINT,
    vote_options INTEGER,

    extra JSONB,

    FOREIGN KEY(event) REFERENCES event(row_id) ON DELETE CASCADE,
    FOREIGN KEY(category) REFERENCES objective_category(name) ON DELETE CASCADE,
    FOREIGN KEY(rewards_currency) REFERENCES currency(name) ON DELETE CASCADE,
    FOREIGN KEY(vote_options) REFERENCES vote_options(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX objective_idx ON objective (id, event);

COMMENT ON TABLE objective IS
'All objectives for all events.
A objective is a group category for selection in an event.';
COMMENT ON COLUMN objective.row_id IS 'Synthetic Unique Key';
COMMENT ON COLUMN objective.id IS
'Event specific objective ID.
Can be non-unique between events (Eg, Ideascale ID for objective).';
COMMENT ON COLUMN objective.event IS 'The specific Event ID this objective is part of.';
COMMENT ON COLUMN objective.category IS
'What category of objective is this.
See the objective_category table for allowed values.';
COMMENT ON COLUMN objective.title IS 'The  title of the objective.';
COMMENT ON COLUMN objective.description IS 'Long form description of the objective.';
COMMENT ON COLUMN objective.deleted IS 'Flag which defines was this objective (challenge) deleted from ideascale or not. DEPRECATED: only used for ideascale compatibility.';
COMMENT ON COLUMN objective.rewards_currency IS 'The currency rewards values are represented as.';
COMMENT ON COLUMN objective.rewards_total IS 'The total reward pool to pay on this objective to winning proposals. In the Objective Currency.';
COMMENT ON COLUMN objective.rewards_total_lovelace IS 'The total reward pool to pay on this objective to winning proposals. In Lovelace.';
COMMENT ON COLUMN objective.proposers_rewards IS 'Not sure how this is different from rewards_total???';
COMMENT ON COLUMN objective.vote_options IS 'The Vote Options applicable to all proposals in this objective.';
COMMENT ON COLUMN objective.extra IS
'Extra Data  for this objective represented as JSON.
"url"."objective" is a URL for more info about the objective.
"highlights" is ???
';
