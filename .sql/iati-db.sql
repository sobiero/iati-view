/*
Navicat MySQL Data Transfer

Source Server         : 79.170.93.5
Source Server Version : 50554
Source Host           : localhost:3306
Source Database       : simon_iati_view

Target Server Type    : MYSQL
Target Server Version : 50554
File Encoding         : 65001

Date: 2017-03-20 17:20:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for activities
-- ----------------------------
DROP TABLE IF EXISTS `activities`;
CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iatifiles_id` int(11) DEFAULT NULL,
  `activity_iati_ref` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(5000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `iatifiles_id` (`iatifiles_id`),
  CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`iatifiles_id`) REFERENCES `iatifiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of activities
-- ----------------------------

-- ----------------------------
-- Table structure for activities_budget
-- ----------------------------
DROP TABLE IF EXISTS `activities_budget`;
CREATE TABLE `activities_budget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(255) DEFAULT NULL,
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `value_date` date DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `activities_budget_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of activities_budget
-- ----------------------------

-- ----------------------------
-- Table structure for activities_countries_map
-- ----------------------------
DROP TABLE IF EXISTS `activities_countries_map`;
CREATE TABLE `activities_countries_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country_iso2` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activity_id` int(11) DEFAULT NULL,
  `percentage_to_country` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `country_iso2` (`country_iso2`,`activity_id`),
  KEY `activities_countries_map_ibfk_1` (`activity_id`),
  CONSTRAINT `activities_countries_map_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of activities_countries_map
-- ----------------------------

-- ----------------------------
-- Table structure for activities_sectors_map
-- ----------------------------
DROP TABLE IF EXISTS `activities_sectors_map`;
CREATE TABLE `activities_sectors_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) DEFAULT NULL,
  `sector_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id` (`activity_id`),
  KEY `sector_id` (`sector_id`),
  CONSTRAINT `activities_sectors_map_ibfk_2` FOREIGN KEY (`sector_id`) REFERENCES `sectors` (`id`),
  CONSTRAINT `activities_sectors_map_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of activities_sectors_map
-- ----------------------------

-- ----------------------------
-- Table structure for activities_transactions
-- ----------------------------
DROP TABLE IF EXISTS `activities_transactions`;
CREATE TABLE `activities_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) DEFAULT NULL,
  `trans_code` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trans_date` date DEFAULT NULL,
  `trans_value` decimal(10,2) DEFAULT NULL,
  `trans_desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `activities_transactions_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of activities_transactions
-- ----------------------------

-- ----------------------------
-- Table structure for countries
-- ----------------------------
DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries` (
  `id` smallint(2) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique ID of the country. Primary Key',
  `iso3` varchar(3) NOT NULL DEFAULT '' COMMENT 'ISO 3166-1 alpha-3 three-letter code',
  `iso2` varchar(2) NOT NULL DEFAULT '' COMMENT 'ISO 3166-1 alpha-2 two-letter code',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'Name of the country in English',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `zoom` tinyint(1) DEFAULT NULL COMMENT 'Optimal zoom when showing country on map',
  `enabled_flag` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Use this country in applications',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_countries_name` (`name`) USING BTREE,
  UNIQUE KEY `idx_countries_code3l` (`iso3`) USING BTREE,
  UNIQUE KEY `idx_countries_code2l` (`iso2`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8 COMMENT='Hold the list of countries. Each country is a row';

-- ----------------------------
-- Records of countries
-- ----------------------------
INSERT INTO `countries` VALUES ('1', 'AFG', 'AF', 'Afghanistan', null, null, null, '1');
INSERT INTO `countries` VALUES ('2', 'ALB', 'AL', 'Albania', null, null, null, '1');
INSERT INTO `countries` VALUES ('3', 'DZA', 'DZ', 'Algeria', null, null, null, '1');
INSERT INTO `countries` VALUES ('4', 'AND', 'AD', 'Andorra', null, null, null, '1');
INSERT INTO `countries` VALUES ('5', 'AGO', 'AO', 'Angola', null, null, null, '1');
INSERT INTO `countries` VALUES ('6', 'ATG', 'AG', 'Antigua and Barbuda', null, null, null, '1');
INSERT INTO `countries` VALUES ('7', 'ARG', 'AR', 'Argentina', null, null, null, '1');
INSERT INTO `countries` VALUES ('8', 'ARM', 'AM', 'Armenia', null, null, null, '1');
INSERT INTO `countries` VALUES ('9', 'AUS', 'AU', 'Australia', null, null, null, '1');
INSERT INTO `countries` VALUES ('10', 'AUT', 'AT', 'Austria', null, null, null, '1');
INSERT INTO `countries` VALUES ('11', 'AZE', 'AZ', 'Azerbaijan', null, null, null, '1');
INSERT INTO `countries` VALUES ('12', 'BHS', 'BS', 'Bahamas', null, null, null, '1');
INSERT INTO `countries` VALUES ('13', 'BHR', 'BH', 'Bahrain', null, null, null, '1');
INSERT INTO `countries` VALUES ('14', 'BGD', 'BD', 'Bangladesh', null, null, null, '1');
INSERT INTO `countries` VALUES ('15', 'BRB', 'BB', 'Barbados', null, null, null, '1');
INSERT INTO `countries` VALUES ('16', 'BLR', 'BY', 'Belarus', null, null, null, '1');
INSERT INTO `countries` VALUES ('17', 'BEL', 'BE', 'Belgium', null, null, null, '1');
INSERT INTO `countries` VALUES ('18', 'BLZ', 'BZ', 'Belize', null, null, null, '1');
INSERT INTO `countries` VALUES ('19', 'BEN', 'BJ', 'Benin', null, null, null, '1');
INSERT INTO `countries` VALUES ('20', 'BTN', 'BT', 'Bhutan', null, null, null, '1');
INSERT INTO `countries` VALUES ('21', 'BIH', 'BA', 'Bosnia and Herzegovina', null, null, null, '1');
INSERT INTO `countries` VALUES ('22', 'BWA', 'BW', 'Botswana', null, null, null, '1');
INSERT INTO `countries` VALUES ('23', 'BRA', 'BR', 'Brazil', null, null, null, '1');
INSERT INTO `countries` VALUES ('24', 'BRN', 'BN', 'Brunei Darussalam', null, null, null, '1');
INSERT INTO `countries` VALUES ('25', 'BGR', 'BG', 'Bulgaria', null, null, null, '1');
INSERT INTO `countries` VALUES ('26', 'BFA', 'BF', 'Burkina Faso', null, null, null, '1');
INSERT INTO `countries` VALUES ('27', 'BDI', 'BI', 'Burundi', null, null, null, '1');
INSERT INTO `countries` VALUES ('28', 'KHM', 'KH', 'Cambodia', null, null, null, '1');
INSERT INTO `countries` VALUES ('29', 'CMR', 'CM', 'Cameroon', null, null, null, '1');
INSERT INTO `countries` VALUES ('30', 'CAN', 'CA', 'Canada', null, null, null, '1');
INSERT INTO `countries` VALUES ('31', 'CPV', 'CV', 'Cape Verde', null, null, null, '1');
INSERT INTO `countries` VALUES ('32', 'CAF', 'CF', 'Central African Republic', null, null, null, '1');
INSERT INTO `countries` VALUES ('33', 'TCD', 'TD', 'Chad', null, null, null, '1');
INSERT INTO `countries` VALUES ('34', 'CHL', 'CL', 'Chile', null, null, null, '1');
INSERT INTO `countries` VALUES ('35', 'CHN', 'CN', 'China', null, null, null, '1');
INSERT INTO `countries` VALUES ('36', 'COL', 'CO', 'Colombia', null, null, null, '1');
INSERT INTO `countries` VALUES ('37', 'COM', 'KM', 'Comoros', null, null, null, '1');
INSERT INTO `countries` VALUES ('38', 'COG', 'CG', 'Congo', null, null, null, '1');
INSERT INTO `countries` VALUES ('39', 'CRI', 'CR', 'Costa Rica', null, null, null, '1');
INSERT INTO `countries` VALUES ('40', 'HRV', 'HR', 'Croatia', null, null, null, '1');
INSERT INTO `countries` VALUES ('41', 'CUB', 'CU', 'Cuba', null, null, null, '1');
INSERT INTO `countries` VALUES ('42', 'CYP', 'CY', 'Cyprus', null, null, null, '1');
INSERT INTO `countries` VALUES ('43', 'CZE', 'CZ', 'Czech Republic', null, null, null, '1');
INSERT INTO `countries` VALUES ('44', 'CIV', 'CI', 'Cote d\'Ivoire', null, null, null, '1');
INSERT INTO `countries` VALUES ('45', 'DNK', 'DK', 'Denmark', null, null, null, '1');
INSERT INTO `countries` VALUES ('46', 'DJI', 'DJ', 'Djibouti', null, null, null, '1');
INSERT INTO `countries` VALUES ('47', 'DMA', 'DM', 'Dominica', null, null, null, '1');
INSERT INTO `countries` VALUES ('48', 'DOM', 'DO', 'Dominican Republic', null, null, null, '1');
INSERT INTO `countries` VALUES ('49', 'ECU', 'EC', 'Ecuador', null, null, null, '1');
INSERT INTO `countries` VALUES ('50', 'EGY', 'EG', 'Egypt', null, null, null, '1');
INSERT INTO `countries` VALUES ('51', 'SLV', 'SV', 'El Salvador', null, null, null, '1');
INSERT INTO `countries` VALUES ('52', 'GNQ', 'GQ', 'Equatorial Guinea', null, null, null, '1');
INSERT INTO `countries` VALUES ('53', 'ERI', 'ER', 'Eritrea', null, null, null, '1');
INSERT INTO `countries` VALUES ('54', 'EST', 'EE', 'Estonia', null, null, null, '1');
INSERT INTO `countries` VALUES ('55', 'ETH', 'ET', 'Ethiopia', null, null, null, '1');
INSERT INTO `countries` VALUES ('56', 'FJI', 'FJ', 'Fiji', null, null, null, '1');
INSERT INTO `countries` VALUES ('57', 'FIN', 'FI', 'Finland', null, null, null, '1');
INSERT INTO `countries` VALUES ('58', 'FRA', 'FR', 'France', null, null, null, '1');
INSERT INTO `countries` VALUES ('59', 'GAB', 'GA', 'Gabon', null, null, null, '1');
INSERT INTO `countries` VALUES ('60', 'GMB', 'GM', 'Gambia', null, null, null, '1');
INSERT INTO `countries` VALUES ('61', 'GEO', 'GE', 'Georgia', null, null, null, '1');
INSERT INTO `countries` VALUES ('62', 'DEU', 'DE', 'Germany', null, null, null, '1');
INSERT INTO `countries` VALUES ('63', 'GHA', 'GH', 'Ghana', null, null, null, '1');
INSERT INTO `countries` VALUES ('64', 'GRC', 'GR', 'Greece', null, null, null, '1');
INSERT INTO `countries` VALUES ('65', 'GRD', 'GD', 'Grenada', null, null, null, '1');
INSERT INTO `countries` VALUES ('66', 'GTM', 'GT', 'Guatemala', null, null, null, '1');
INSERT INTO `countries` VALUES ('67', 'GIN', 'GN', 'Guinea-Conakry', null, null, null, '1');
INSERT INTO `countries` VALUES ('68', 'GNB', 'GW', 'Guinea-Bissau', null, null, null, '1');
INSERT INTO `countries` VALUES ('69', 'GUY', 'GY', 'Guyana', null, null, null, '1');
INSERT INTO `countries` VALUES ('70', 'HTI', 'HT', 'Haiti', null, null, null, '1');
INSERT INTO `countries` VALUES ('71', 'HND', 'HN', 'Honduras', null, null, null, '1');
INSERT INTO `countries` VALUES ('72', 'HUN', 'HU', 'Hungary', null, null, null, '1');
INSERT INTO `countries` VALUES ('73', 'ISL', 'IS', 'Iceland', null, null, null, '1');
INSERT INTO `countries` VALUES ('74', 'IND', 'IN', 'India', null, null, null, '1');
INSERT INTO `countries` VALUES ('75', 'IDN', 'ID', 'Indonesia', null, null, null, '1');
INSERT INTO `countries` VALUES ('76', 'IRQ', 'IQ', 'Iraq', null, null, null, '1');
INSERT INTO `countries` VALUES ('77', 'IRL', 'IE', 'Ireland', null, null, null, '1');
INSERT INTO `countries` VALUES ('78', 'ISR', 'IL', 'Israel', null, null, null, '1');
INSERT INTO `countries` VALUES ('79', 'ITA', 'IT', 'Italy', null, null, null, '1');
INSERT INTO `countries` VALUES ('80', 'JAM', 'JM', 'Jamaica', null, null, null, '1');
INSERT INTO `countries` VALUES ('81', 'JPN', 'JP', 'Japan', null, null, null, '1');
INSERT INTO `countries` VALUES ('82', 'JOR', 'JO', 'Jordan', null, null, null, '1');
INSERT INTO `countries` VALUES ('83', 'KAZ', 'KZ', 'Kazakhstan', null, null, null, '1');
INSERT INTO `countries` VALUES ('84', 'KEN', 'KE', 'Kenya', null, null, null, '1');
INSERT INTO `countries` VALUES ('85', 'KIR', 'KI', 'Kiribati', null, null, null, '1');
INSERT INTO `countries` VALUES ('86', 'KWT', 'KW', 'Kuwait', null, null, null, '1');
INSERT INTO `countries` VALUES ('87', 'KGZ', 'KG', 'Kyrgyzstan', null, null, null, '1');
INSERT INTO `countries` VALUES ('88', 'LAO', 'LA', 'Lao People\'s Democratic Republic', null, null, null, '1');
INSERT INTO `countries` VALUES ('89', 'LVA', 'LV', 'Latvia', null, null, null, '1');
INSERT INTO `countries` VALUES ('90', 'LBN', 'LB', 'Lebanon', null, null, null, '1');
INSERT INTO `countries` VALUES ('91', 'LSO', 'LS', 'Lesotho', null, null, null, '1');
INSERT INTO `countries` VALUES ('92', 'LBR', 'LR', 'Liberia', null, null, null, '1');
INSERT INTO `countries` VALUES ('93', 'LBY', 'LY', 'Libyan Arab Jamahiriya', null, null, null, '1');
INSERT INTO `countries` VALUES ('94', 'LIE', 'LI', 'Liechtenstein', null, null, null, '1');
INSERT INTO `countries` VALUES ('95', 'LTU', 'LT', 'Lithuania', null, null, null, '1');
INSERT INTO `countries` VALUES ('96', 'LUX', 'LU', 'Luxembourg', null, null, null, '1');
INSERT INTO `countries` VALUES ('97', 'MDG', 'MG', 'Madagascar', null, null, null, '1');
INSERT INTO `countries` VALUES ('98', 'MWI', 'MW', 'Malawi', null, null, null, '1');
INSERT INTO `countries` VALUES ('99', 'MYS', 'MY', 'Malaysia', null, null, null, '1');
INSERT INTO `countries` VALUES ('100', 'MDV', 'MV', 'Maldives', null, null, null, '1');
INSERT INTO `countries` VALUES ('101', 'MLI', 'ML', 'Mali', null, null, null, '1');
INSERT INTO `countries` VALUES ('102', 'MLT', 'MT', 'Malta', null, null, null, '1');
INSERT INTO `countries` VALUES ('103', 'MHL', 'MH', 'Marshall Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('104', 'MRT', 'MR', 'Mauritania', null, null, null, '1');
INSERT INTO `countries` VALUES ('105', 'MUS', 'MU', 'Mauritius', null, null, null, '1');
INSERT INTO `countries` VALUES ('106', 'MEX', 'MX', 'Mexico', null, null, null, '1');
INSERT INTO `countries` VALUES ('107', 'MCO', 'MC', 'Monaco', null, null, null, '1');
INSERT INTO `countries` VALUES ('108', 'MNG', 'MN', 'Mongolia', null, null, null, '1');
INSERT INTO `countries` VALUES ('109', 'MNE', 'ME', 'Montenegro', null, null, null, '1');
INSERT INTO `countries` VALUES ('110', 'MAR', 'MA', 'Morocco', null, null, null, '1');
INSERT INTO `countries` VALUES ('111', 'MOZ', 'MZ', 'Mozambique', null, null, null, '1');
INSERT INTO `countries` VALUES ('112', 'MMR', 'MM', 'Myanmar', null, null, null, '1');
INSERT INTO `countries` VALUES ('113', 'NAM', 'NA', 'Namibia', null, null, null, '1');
INSERT INTO `countries` VALUES ('114', 'NRU', 'NR', 'Nauru', null, null, null, '1');
INSERT INTO `countries` VALUES ('115', 'NPL', 'NP', 'Nepal', null, null, null, '1');
INSERT INTO `countries` VALUES ('116', 'NLD', 'NL', 'Netherlands', null, null, null, '1');
INSERT INTO `countries` VALUES ('117', 'NZL', 'NZ', 'New Zealand', null, null, null, '1');
INSERT INTO `countries` VALUES ('118', 'NIC', 'NI', 'Nicaragua', null, null, null, '1');
INSERT INTO `countries` VALUES ('119', 'NER', 'NE', 'Niger', null, null, null, '1');
INSERT INTO `countries` VALUES ('120', 'NGA', 'NG', 'Nigeria', null, null, null, '1');
INSERT INTO `countries` VALUES ('121', 'NOR', 'NO', 'Norway', null, null, null, '1');
INSERT INTO `countries` VALUES ('122', 'OMN', 'OM', 'Oman', null, null, null, '1');
INSERT INTO `countries` VALUES ('123', 'PAK', 'PK', 'Pakistan', null, null, null, '1');
INSERT INTO `countries` VALUES ('124', 'PLW', 'PW', 'Palau', null, null, null, '1');
INSERT INTO `countries` VALUES ('125', 'PAN', 'PA', 'Panama', null, null, null, '1');
INSERT INTO `countries` VALUES ('126', 'PNG', 'PG', 'Papua New Guinea', null, null, null, '1');
INSERT INTO `countries` VALUES ('127', 'PRY', 'PY', 'Paraguay', null, null, null, '1');
INSERT INTO `countries` VALUES ('128', 'PER', 'PE', 'Peru', null, null, null, '1');
INSERT INTO `countries` VALUES ('129', 'PHL', 'PH', 'Philippines', null, null, null, '1');
INSERT INTO `countries` VALUES ('130', 'POL', 'PL', 'Poland', null, null, null, '1');
INSERT INTO `countries` VALUES ('131', 'PRT', 'PT', 'Portugal', null, null, null, '1');
INSERT INTO `countries` VALUES ('132', 'QAT', 'QA', 'Qatar', null, null, null, '1');
INSERT INTO `countries` VALUES ('133', 'ROU', 'RO', 'Romania', null, null, null, '1');
INSERT INTO `countries` VALUES ('134', 'RUS', 'RU', 'Russian Federation', null, null, null, '1');
INSERT INTO `countries` VALUES ('135', 'RWA', 'RW', 'Rwanda', null, null, null, '1');
INSERT INTO `countries` VALUES ('136', 'KNA', 'KN', 'Saint Kitts and Nevis', null, null, null, '1');
INSERT INTO `countries` VALUES ('137', 'LCA', 'LC', 'Saint Lucia', null, null, null, '1');
INSERT INTO `countries` VALUES ('138', 'VCT', 'VC', 'Saint Vincent and the Grenadines', null, null, null, '1');
INSERT INTO `countries` VALUES ('139', 'WSM', 'WS', 'Samoa', null, null, null, '1');
INSERT INTO `countries` VALUES ('140', 'SMR', 'SM', 'San Marino', null, null, null, '1');
INSERT INTO `countries` VALUES ('141', 'STP', 'ST', 'Sao Tome and Principe', null, null, null, '1');
INSERT INTO `countries` VALUES ('142', 'SAU', 'SA', 'Saudi Arabia', null, null, null, '1');
INSERT INTO `countries` VALUES ('143', 'SEN', 'SN', 'Senegal', null, null, null, '1');
INSERT INTO `countries` VALUES ('144', 'SRB', 'RS', 'Serbia', null, null, null, '1');
INSERT INTO `countries` VALUES ('145', 'SYC', 'SC', 'Seychelles', null, null, null, '1');
INSERT INTO `countries` VALUES ('146', 'SLE', 'SL', 'Sierra Leone', null, null, null, '1');
INSERT INTO `countries` VALUES ('147', 'SGP', 'SG', 'Singapore', null, null, null, '1');
INSERT INTO `countries` VALUES ('148', 'SVK', 'SK', 'Slovakia', null, null, null, '1');
INSERT INTO `countries` VALUES ('149', 'SVN', 'SI', 'Slovenia', null, null, null, '1');
INSERT INTO `countries` VALUES ('150', 'SLB', 'SB', 'Solomon Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('151', 'SOM', 'SO', 'Somalia', null, null, null, '1');
INSERT INTO `countries` VALUES ('152', 'ZAF', 'ZA', 'South Africa', null, null, null, '1');
INSERT INTO `countries` VALUES ('153', 'ESP', 'ES', 'Spain', null, null, null, '1');
INSERT INTO `countries` VALUES ('154', 'LKA', 'LK', 'Sri Lanka', null, null, null, '1');
INSERT INTO `countries` VALUES ('155', 'SDN', 'SD', 'Sudan', null, null, null, '1');
INSERT INTO `countries` VALUES ('156', 'SUR', 'SR', 'Suriname', null, null, null, '1');
INSERT INTO `countries` VALUES ('157', 'SWZ', 'SZ', 'Swaziland', null, null, null, '1');
INSERT INTO `countries` VALUES ('158', 'SWE', 'SE', 'Sweden', null, null, null, '1');
INSERT INTO `countries` VALUES ('159', 'CHE', 'CH', 'Switzerland', null, null, null, '1');
INSERT INTO `countries` VALUES ('160', 'SYR', 'SY', 'Syrian Arab Republic', null, null, null, '1');
INSERT INTO `countries` VALUES ('161', 'TJK', 'TJ', 'Tajikistan', null, null, null, '1');
INSERT INTO `countries` VALUES ('162', 'THA', 'TH', 'Thailand', null, null, null, '1');
INSERT INTO `countries` VALUES ('163', 'TLS', 'TL', 'Timor-Leste', null, null, null, '1');
INSERT INTO `countries` VALUES ('164', 'TGO', 'TG', 'Togo', null, null, null, '1');
INSERT INTO `countries` VALUES ('165', 'TON', 'TO', 'Tonga', null, null, null, '1');
INSERT INTO `countries` VALUES ('166', 'TTO', 'TT', 'Trinidad and Tobago', null, null, null, '1');
INSERT INTO `countries` VALUES ('167', 'TUN', 'TN', 'Tunisia', null, null, null, '1');
INSERT INTO `countries` VALUES ('168', 'TUR', 'TR', 'Turkey', null, null, null, '1');
INSERT INTO `countries` VALUES ('169', 'TKM', 'TM', 'Turkmenistan', null, null, null, '1');
INSERT INTO `countries` VALUES ('170', 'TUV', 'TV', 'Tuvalu', null, null, null, '1');
INSERT INTO `countries` VALUES ('171', 'UGA', 'UG', 'Uganda', null, null, null, '1');
INSERT INTO `countries` VALUES ('172', 'UKR', 'UA', 'Ukraine', null, null, null, '1');
INSERT INTO `countries` VALUES ('173', 'ARE', 'AE', 'United Arab Emirates', null, null, null, '1');
INSERT INTO `countries` VALUES ('174', 'URY', 'UY', 'Uruguay', null, null, null, '1');
INSERT INTO `countries` VALUES ('175', 'UZB', 'UZ', 'Uzbekistan', null, null, null, '1');
INSERT INTO `countries` VALUES ('176', 'VUT', 'VU', 'Vanuatu', null, null, null, '1');
INSERT INTO `countries` VALUES ('177', 'VNM', 'VN', 'Viet Nam', null, null, null, '1');
INSERT INTO `countries` VALUES ('178', 'YEM', 'YE', 'Yemen', null, null, null, '1');
INSERT INTO `countries` VALUES ('179', 'ZMB', 'ZM', 'Zambia', null, null, null, '1');
INSERT INTO `countries` VALUES ('180', 'ZWE', 'ZW', 'Zimbabwe', null, null, null, '1');
INSERT INTO `countries` VALUES ('181', 'COK', 'CK', 'Cook Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('182', 'BOL', 'BO', 'Bolivia (Plurinational State of)', null, null, null, '1');
INSERT INTO `countries` VALUES ('183', 'COD', 'CD', 'Democratic Republic of the Congo', null, null, null, '1');
INSERT INTO `countries` VALUES ('184', 'EUR', 'EU', 'European Union', null, null, null, '1');
INSERT INTO `countries` VALUES ('185', 'FSM', 'FM', 'Micronesia (Federated States of)', null, null, null, '1');
INSERT INTO `countries` VALUES ('186', 'GBR', 'GB', 'United Kingdom of Great Britain and Northern Ireland', null, null, null, '1');
INSERT INTO `countries` VALUES ('187', 'IRN', 'IR', 'Iran (Islamic Republic of)', null, null, null, '1');
INSERT INTO `countries` VALUES ('188', 'PRK', 'KP', 'Democratic People\'s Republic of Korea', null, null, null, '1');
INSERT INTO `countries` VALUES ('189', 'KOR', 'KR', 'Republic of Korea', null, null, null, '1');
INSERT INTO `countries` VALUES ('190', 'MDA', 'MD', 'Republic of Moldova', null, null, null, '1');
INSERT INTO `countries` VALUES ('191', 'MKD', 'MK', 'The former Yugoslav Republic of Macedonia', null, null, null, '1');
INSERT INTO `countries` VALUES ('192', 'NIU', 'NU', 'Niue', null, null, null, '1');
INSERT INTO `countries` VALUES ('193', 'TZA', 'TZ', 'United Republic of Tanzania', null, null, null, '1');
INSERT INTO `countries` VALUES ('194', 'VEN', 'VE', 'Venezuela (Bolivarian Republic of)', null, null, null, '1');
INSERT INTO `countries` VALUES ('195', 'AIA', 'AI', 'Anguilla', null, null, null, '1');
INSERT INTO `countries` VALUES ('196', 'ATA', 'AQ', 'Antarctica', null, null, null, '1');
INSERT INTO `countries` VALUES ('197', 'ASM', 'AS', 'American Samoa', null, null, null, '1');
INSERT INTO `countries` VALUES ('198', 'ABW', 'AW', 'Aruba', null, null, null, '1');
INSERT INTO `countries` VALUES ('199', 'ALA', 'AX', 'Aland Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('200', 'BLM', 'BL', 'Saint Barthélemy', null, null, null, '1');
INSERT INTO `countries` VALUES ('201', 'BMU', 'BM', 'Bermuda', null, null, null, '1');
INSERT INTO `countries` VALUES ('202', 'BES', 'BQ', 'Bonaire, Saint Eustatius And Saba', null, null, null, '1');
INSERT INTO `countries` VALUES ('203', 'BVT', 'BV', 'Bouvet Island', null, null, null, '1');
INSERT INTO `countries` VALUES ('204', 'CCK', 'CC', 'Cocos (Keeling) Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('205', 'CUW', 'CW', 'Curaçao', null, null, null, '1');
INSERT INTO `countries` VALUES ('206', 'CXR', 'CX', 'Christmas Island', null, null, null, '1');
INSERT INTO `countries` VALUES ('207', 'ESH', 'EH', 'Western Sahara', null, null, null, '1');
INSERT INTO `countries` VALUES ('208', 'FLK', 'FK', 'Falkland Islands (Malvinas)', null, null, null, '1');
INSERT INTO `countries` VALUES ('209', 'FRO', 'FO', 'Faeroe Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('210', 'GUF', 'GF', 'French Guiana', null, null, null, '1');
INSERT INTO `countries` VALUES ('211', 'GGY', 'GG', 'Guernsey', null, null, null, '1');
INSERT INTO `countries` VALUES ('212', 'GIB', 'GI', 'Gibraltar', null, null, null, '1');
INSERT INTO `countries` VALUES ('213', 'GRL', 'GL', 'Greenland', null, null, null, '1');
INSERT INTO `countries` VALUES ('214', 'GLP', 'GP', 'Guadeloupe', null, null, null, '1');
INSERT INTO `countries` VALUES ('215', 'SGS', 'GS', 'South Georgia and the South Sandwich Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('216', 'GUM', 'GU', 'Guam', null, null, null, '1');
INSERT INTO `countries` VALUES ('217', 'HKG', 'HK', 'Hong Kong Special Administrative Region of China', null, null, null, '1');
INSERT INTO `countries` VALUES ('218', 'HMD', 'HM', 'Heard Island And McDonald Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('219', 'IMN', 'IM', 'Isle of Man', null, null, null, '1');
INSERT INTO `countries` VALUES ('220', 'IOT', 'IO', 'British Indian Ocean Territory', null, null, null, '1');
INSERT INTO `countries` VALUES ('221', 'JEY', 'JE', 'Jersey', null, null, null, '1');
INSERT INTO `countries` VALUES ('222', 'CYM', 'KY', 'Cayman Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('223', 'MAF', 'MF', 'Saint Martin (French part)', null, null, null, '1');
INSERT INTO `countries` VALUES ('224', 'MAC', 'MO', 'Macao Special Administrative Region of China', null, null, null, '1');
INSERT INTO `countries` VALUES ('225', 'MNP', 'MP', 'Northern Mariana Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('226', 'MTQ', 'MQ', 'Martinique', null, null, null, '1');
INSERT INTO `countries` VALUES ('227', 'MSR', 'MS', 'Montserrat', null, null, null, '1');
INSERT INTO `countries` VALUES ('228', 'NCL', 'NC', 'New Caledonia', null, null, null, '1');
INSERT INTO `countries` VALUES ('229', 'NFK', 'NF', 'Norfolk Island', null, null, null, '1');
INSERT INTO `countries` VALUES ('230', 'PYF', 'PF', 'French Polynesia', null, null, null, '1');
INSERT INTO `countries` VALUES ('231', 'SPM', 'PM', 'Saint Pierre and Miquelon', null, null, null, '1');
INSERT INTO `countries` VALUES ('232', 'PCN', 'PN', 'Pitcairn', null, null, null, '1');
INSERT INTO `countries` VALUES ('233', 'PRI', 'PR', 'Puerto Rico', null, null, null, '1');
INSERT INTO `countries` VALUES ('234', 'PSE', 'PS', 'Occupied Palestinian Territory', null, null, null, '1');
INSERT INTO `countries` VALUES ('235', 'REU', 'RE', 'Réunion', null, null, null, '1');
INSERT INTO `countries` VALUES ('236', 'SHN', 'SH', 'Saint Helena', null, null, null, '1');
INSERT INTO `countries` VALUES ('237', 'SJM', 'SJ', 'Svalbard and Jan Mayen Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('238', 'SXM', 'SX', 'Sint Maarten', null, null, null, '1');
INSERT INTO `countries` VALUES ('239', 'TCA', 'TC', 'Turks and Caicos Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('240', 'ATF', 'TF', 'French Southern and Antarctic Lands', null, null, null, '1');
INSERT INTO `countries` VALUES ('241', 'TKL', 'TK', 'Tokelau', null, null, null, '1');
INSERT INTO `countries` VALUES ('242', 'TWN', 'TW', 'Taiwan', null, null, null, '1');
INSERT INTO `countries` VALUES ('243', 'UMI', 'UM', 'United States Minor Outlying Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('244', 'USA', 'US', 'United States of America', null, null, null, '1');
INSERT INTO `countries` VALUES ('245', 'VAT', 'VA', 'Holy See', null, null, null, '1');
INSERT INTO `countries` VALUES ('246', 'VGB', 'VG', 'British Virgin Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('247', 'VIR', 'VI', 'US Virgin Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('248', 'WLF', 'WF', 'Wallis and Futuna Islands', null, null, null, '1');
INSERT INTO `countries` VALUES ('249', 'MYT', 'YT', 'Mayotte', null, null, null, '1');
INSERT INTO `countries` VALUES ('250', 'SSD', 'SS', 'South Sudan', null, null, null, '1');
INSERT INTO `countries` VALUES ('251', 'ANT', 'AN', 'Netherlands Antilles', null, null, null, '1');

-- ----------------------------
-- Table structure for iatifiles
-- ----------------------------
DROP TABLE IF EXISTS `iatifiles`;
CREATE TABLE `iatifiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `iati_file_url` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iati_ref` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_file_map` (`organization_id`,`iati_file_url`) USING BTREE,
  CONSTRAINT `iatifiles_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of iatifiles
-- ----------------------------

-- ----------------------------
-- Table structure for import_cache
-- ----------------------------
DROP TABLE IF EXISTS `import_cache`;
CREATE TABLE `import_cache` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `url` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` longtext COLLATE utf8mb4_unicode_ci,
  `date_loaded` datetime DEFAULT NULL,
  `imported_flag` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of import_cache
-- ----------------------------

-- ----------------------------
-- Table structure for organizations
-- ----------------------------
DROP TABLE IF EXISTS `organizations`;
CREATE TABLE `organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of organizations
-- ----------------------------

-- ----------------------------
-- Table structure for sectors
-- ----------------------------
DROP TABLE IF EXISTS `sectors`;
CREATE TABLE `sectors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sectors
-- ----------------------------

-- ----------------------------
-- Table structure for transaction_codes
-- ----------------------------
DROP TABLE IF EXISTS `transaction_codes`;
CREATE TABLE `transaction_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numeric_value` int(11) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `desc` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of transaction_codes
-- ----------------------------
INSERT INTO `transaction_codes` VALUES ('1', 'IF', '1', 'Incoming Funds', 'Funds recieved for use on the activity, which can be from an external or internal source.');
INSERT INTO `transaction_codes` VALUES ('2', 'C', '2', 'Commitment', 'A firm, written obligation from a donor or provider to provide a specified amount of funds, under particular terms and conditions, for specific purposes, for the benefit of the recipient');
INSERT INTO `transaction_codes` VALUES ('3', 'D', '3', 'Disbursement', 'Outgoing funds that are placed at the disposal of a recipient government or organisation, or funds transferred between two separately reported activities.Under IATI traceability standards the recipient of a disbursement should also be required to report their activities to IATI.');
INSERT INTO `transaction_codes` VALUES ('4', 'E', '4', 'Expenditure', 'Outgoing funds that are spent on goods and services for the activity. The recipients of expenditures fall outside of IATI traceability standards.');
INSERT INTO `transaction_codes` VALUES ('5', 'IR', '5', ' Interest Repayment', 'The actual amount of interest paid on a loan or line of credit, including fees.');
INSERT INTO `transaction_codes` VALUES ('6', 'LR', '6', ' Loan Repayment', 'The actual amount of principal (amortisation) repaid, including any arrears.');
INSERT INTO `transaction_codes` VALUES ('7', 'R', '7', 'Reimbursement', 'A type of disbursement that covers funds that have already been spent by the recipient, as agreed in the terms of the grant or loan');
INSERT INTO `transaction_codes` VALUES ('8', 'QP', '8', ' Purchase of Equity', 'Outgoing funds that are used to purchase equity in a business');
INSERT INTO `transaction_codes` VALUES ('9', 'Q3', '9', ' Sale of Equity', 'Incoming funds from the sale of equity.');
INSERT INTO `transaction_codes` VALUES ('10', 'CG', '10', ' Credit Guarantee', 'A commitment made by a funding organisation to underwrite a loan or line of credit entered into by a third party');
INSERT INTO `transaction_codes` VALUES ('11', 'IC', '11', ' Incoming Commitment', 'A firm, written obligation from a donor or provider to provide a specified amount of funds, under particular terms and conditions, reported by a recipient for this activity');

TRUNCATE TABLE activities_budget;
TRUNCATE TABLE activities_transactions;
TRUNCATE TABLE activities_countries_map;
TRUNCATE TABLE activities_sectors_map;

DELETE FROM sectors;
ALTER TABLE `sectors`
AUTO_INCREMENT=1;
DELETE FROM activities;
ALTER TABLE `activities`
AUTO_INCREMENT=1;
DELETE FROM iatifiles;
ALTER TABLE `iatifiles`
AUTO_INCREMENT=1;
DELETE FROM organizations;
ALTER TABLE `organizations`
AUTO_INCREMENT=1;
TRUNCATE TABLE import_cache;