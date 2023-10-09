INSERT INTO contribution 
(row_id, stake_public_key, snapshot_id, voting_key, voting_weight, voting_key_idx, value, voting_group, reward_address)
VALUES 
(1, 'stake_public_key_1', 1, 'voting_key_1', 1, 1, 140, 'rep', 'addrrreward_address_1'),
(2, 'stake_public_key_2', 1, 'voting_key_1', 1, 1, 110, 'rep', 'reward_address_2'),
(3, 'stake_public_key_1', 1, 'voting_key_2', 1, 1, 100, 'rep', 'reward_address_1'),
(4, 'stake_public_key_3', 1, 'voting_key_2', 1, 1, 50, 'rep', 'reward_address_3'),
(5, 'stake_public_key_4', 1, 'voting_key_3', 1, 1, 350, 'direct', 'reward_address_4'),
(6, 'stake_public_key_5', 1, 'voting_key_5', 1, 1, 250, 'direct', 'reward_address_5'),

(7, 'stake_public_key_1', 2, 'voting_key_1', 1, 1, 140, 'rep', 'addrrreward_address_1'),
(8, 'stake_public_key_2', 2, 'voting_key_1', 1, 1, 110, 'rep', 'reward_address_2'),
(9, 'stake_public_key_1', 2, 'voting_key_2', 1, 1, 100, 'rep', 'addrrreward_address_1'),
(10, 'stake_public_key_3', 2, 'voting_key_2', 1, 1, 50, 'rep', 'reward_address_3'),
(11, 'stake_public_key_4', 2, 'voting_key_3', 1, 1, 350, 'direct', 'reward_address_4'),
(12, 'stake_public_key_5', 2, 'voting_key_5', 1, 1, 250, 'direct', 'reward_address_5'),

(13, 'stake_public_key_1', 3, 'voting_key_1', 1, 1, 140, 'rep', 'addrrreward_address_1'),
(14, 'stake_public_key_2', 3, 'voting_key_1', 1, 1, 110, 'rep', 'reward_address_2'),
(15, 'stake_public_key_1', 3, 'voting_key_2', 1, 1, 100, 'rep', 'addrrreward_address_1'),
(16, 'stake_public_key_3', 3, 'voting_key_2', 1, 1, 50, 'rep', 'reward_address_4'),
(17, 'stake_public_key_4', 3, 'voting_key_3', 1, 1, 350, 'direct', 'reward_address_5'),
(18, 'stake_public_key_5', 3, 'voting_key_5', 1, 1, 250, 'direct', 'reward_address_5');
