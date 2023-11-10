INSERT INTO objective
(
  row_id,
  id,
  event,
  category,
  title,
  description,
  rewards_currency,
  rewards_total,
  proposers_rewards,
  vote_options,
  extra
)
VALUES
(
  1,
  1, 1,
  'catalyst-simple', 'title 1', 'description 1',
  'ADA', 100, 100, 1,
  '{
    "url": "objective 1 url",
    "sponsor": "objective 1 sponsor",
    "video": "objective 1 video"
   }'
),
(
  2,
  2, 1,
  'catalyst-native', 'title 2', 'description 2',
  NULL, NULL, NULL, NULL,
  NULL
),
(
  3,
  3, 4,
  'catalyst-simple', 'title 3', 'description 3',
  'ADA', 100, 100, 1,
  '{
    "url": "objective 3 url",
    "sponsor": "objective 3 sponsor",
    "video": "objective 3 video"
   }'
),
(
  4,
  4, 4,
  'catalyst-native', 'title 4', 'description 4',
  NULL, NULL, NULL, NULL,
  NULL
);
