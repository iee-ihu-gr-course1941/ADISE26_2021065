CREATE TABLE `game_board`( -- 5x5 πίνακας/ταμπλό όπου αναπαριστούνται τα 25 τετράγωνα του παιχνιδιού
`x` INT NOT NULL, -- στήλη 1 εώς 5
`y` INT NOT NULL, -- γραμμή 1 εώς 5
`piece_type` enum('Master','Student') NOT NULL, -- σύμφωνα με το wikipedia, στο onitama υπάρχουν δύο τύποι πιονών/κομματιών, Master και Student
`piece_color` enum('Red','Blue') NOT NULL, -- σύμφωνα με εικόνες που μπορεί να βρει κανείς σχετικά με το παιχνίδι, τα χρώματα των πιονών είναι είτε κόκκινα είτε μπλε
PRIMARY KEY (`x`,`y`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;