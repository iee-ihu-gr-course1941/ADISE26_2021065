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
