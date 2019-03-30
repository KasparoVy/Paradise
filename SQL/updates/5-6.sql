#Updating the SQL from version 5 to version 6. -KasparoVv
#Add a field to the characters table to hold scream voice.
ALTER TABLE `characters`
	ADD `scream` varchar(45) NOT NULL DEFAULT 'Default' AFTER `autohiss`;
