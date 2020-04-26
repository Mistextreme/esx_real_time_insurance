CREATE TABLE `insurance` (
  `identifier` varchar(100) NOT NULL,
  `posiada` tinyint(1) DEFAULT NULL,
  `czas` datetime NOT NULL,
  `nick` varchar(100) NOT NULL,
  `JID` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `insurance`
  ADD PRIMARY KEY (`identifier`);
