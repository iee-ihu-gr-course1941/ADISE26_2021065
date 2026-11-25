CREATE TABLE `game_board`( -- 5x5 πίνακας/ταμπλό όπου αναπαριστούνται τα 25 τετράγωνα του παιχνιδιού
`x` INT NOT NULL, -- στήλη 1 εώς 5
`y` INT NOT NULL, -- γραμμή 1 εώς 5
`piece_type` enum('Master','Student') NOT NULL, -- σύμφωνα με το wikipedia, στο onitama υπάρχουν δύο τύποι πιονών/κομματιών, Master και Student
`piece_color` enum('Red','Blue') NOT NULL, -- σύμφωνα με εικόνες που μπορεί να βρει κανείς σχετικά με το παιχνίδι, τα χρώματα των πιονών είναι είτε κόκκινα είτε μπλε
PRIMARY KEY (`x`,`y`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `players`(-- πίνακας με τα στοιχεία των παικτών
`username` varchar(30) DEFAULT NULL, -- όνομα παίκτη το οποίο θα είναι null μέχρι να κάνει login
`piece_color` enum('Red','Blue') NOT NULL, -- το χρώμα των πιονιών του παίκτη όπου θα αποτελέι και το primary key
`token` varchar(255) DEFAULT NULL, -- μοναδικό session token για την επικοινωνία με το API
`last_action` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- χρόνος από την τελευταία κίνηση του παίκτη
PRIMARY KEY (`piece_color`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin; 

INSERT INTO `players` (`username`, `piece_color`, `token`) VALUES
(NULL, 'Red', NULL),
(NULL, 'Blue', NULL);

CREATE TABLE `game_status`(
`status` enum('Start','End','Abort','Not Active','Initialized') NOT NULL DEFAULT 'Not Active', -- σε ποιο σημείο ή φάση του παιχνιδιού βρισκόμαστε
`player_turn` enum('Red','Blue') DEFAULT NULL, -- ποιος παίκτης έχει σειρά
`result` enum('Red Win','Blue Win','Draw') DEFAULT NULL, -- ποιος παίκτης νίκησε ή αν ήρθε ισοπαλία
`last_change` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- πότε έγινε η τελευταία ενημέρωση του status του παιχνιδιού
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `game_status` (`status`, `player_turn`, `result`) VALUES ('Not Active', NULL, NULL);

CREATE TABLE `cards`(
`id` INT NOT NULL AUTO_INCREMENT, -- σύμφωνα με το wikipedia υπάρχουν 16 κάρτες οπότε θα γίνεται αυτόματη ανάθεση για το id από 1 εώς 16
`card_name` varchar(30) NOT NULL UNIQUE, -- κάθε κάρτα έχει μια μοναδική ονομασία π.χ. Tiger,Dragon,Monkey κτλ
`card_location` enum('Red','Blue','Neutral','Deck') NOT NULL DEFAULT 'Deck', -- που βρίσκεται η κάρτα στην παρτίδα, το Neutral σημαίνει ότι βρίσκεται στη μέση για ανταλλαγή
`first_player` enum('Red','Blue') NOT NULL, -- παίζει πρώτος`moves` varchar(255) NOT NULL, -- json array που σχετίζεται με τις κινήσεις
PRIMARY KEY(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `cards` (`card_name`, `moves`, `first_player`) VALUES
('Tiger', '[[0,2],[0,-1]]', 'Blue'), -- αν πέσει στη μέση (Neutral) παίζει πρώτος ο Blue· κινήσεις: 2 μπροστά ή 1 πίσω
('Dragon', '[[-2,1],[2,1],[-1,-1],[1,-1]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 2 αριστερά/δεξιά & 1 μπροστά, ή 1 διαγώνια πίσω
('Frog', '[[-2,0],[-1,1],[1,-1]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 2 αριστερά, 1 διαγώνια μπροστά-αριστερά, ή 1 διαγώνια πίσω-δεξιά
('Rabbit', '[[-1,-1],[1,1],[2,0]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 2 δεξιά, 1 διαγώνια μπροστά-δεξιά, ή 1 διαγώνια πίσω-αριστερά
('Crab', '[[-2,0],[0,1],[2,0]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 2 αριστερά, 2 δεξιά, ή 1 μπροστά
('Elephant', '[[-1,0],[-1,1],[1,0],[1,1]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 1 αριστερά/δεξιά ή 1 διαγώνια μπροστά (αριστερά/δεξιά)
('Goose', '[[-1,0],[-1,1],[1,0],[1,-1]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 1 αριστερά/δεξιά, 1 διαγώνια μπροστά-αριστερά, ή 1 διαγώνια πίσω-δεξιά
('Rooster', '[[-1,0],[-1,-1],[1,0],[1,1]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 1 αριστερά/δεξιά, 1 διαγώνια μπροστά-δεξιά, ή 1 διαγώνια πίσω-αριστερά
('Monkey', '[[-1,1],[1,1],[-1,-1],[1,-1]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 1 τετράγωνο και στις 4 διαγώνιους
('Mantis', '[[-1,1],[1,1],[0,-1]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 1 διαγώνια μπροστά (αριστερά/δεξιά) ή 1 πίσω
('Horse', '[[-1,0],[0,1],[0,-1]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 1 μπροστά, 1 πίσω, ή 1 αριστερά
('Ox', '[[0,1],[1,0],[0,-1]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 1 μπροστά, 1 πίσω, ή 1 δεξιά
('Crane', '[[0,1],[-1,-1],[1,-1]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 1 μπροστά ή 1 διαγώνια πίσω (αριστερά/δεξιά)
('Boar', '[[-1,0],[0,1],[1,0]]', 'Red'), -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 1 μπροστά, 1 αριστερά, ή 1 δεξιά
('Eel', '[[-1,1],[-1,-1],[1,0]]', 'Blue'), -- αν πέσει Neutral παίζει πρώτος ο Blue· κινήσεις: 1 διαγώνια μπροστά/πίσω αριστερά, ή 1 δεξιά
('Cobra', '[[-1,0],[1,1],[1,-1]]', 'Red'); -- αν πέσει Neutral παίζει πρώτος ο Red· κινήσεις: 1 αριστερά, ή 1 διαγώνια μπροστά/πίσω δεξιά