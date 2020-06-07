
--
-- Дамп для evoLetters
--

CREATE TABLE IF NOT EXISTS `{PREFIX}el_letters` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `subject` varchar(128) NOT NULL,
  `content` text NOT NULL,
  `tpl` int(11) NOT NULL,
  `method` text NOT NULL,
  `count` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

INSERT INTO `{PREFIX}el_letters` (`id`, `name`, `subject`, `content`, `tpl`, `method`, `count`) VALUES
(1, 'Подтверждение регистрации', 'Подтверждение регистрации', '<p>Проверка работы модуля отправки с использованием метода SMS2.</p>', 1, 'modxmail', 0),
(2, 'Валидация писем', '', '', 2, 'emailverification', 0);

CREATE TABLE IF NOT EXISTS `{PREFIX}el_methods` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `method` varchar(64) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

INSERT INTO `{PREFIX}el_methods` (`id`, `name`, `method`) VALUES
(3, 'Отправка MODX', 'modxmail'),
(4, 'Рассылка СМС-сообщений', 'smsc'),
(5, 'Smtp.bz', 'smtp.bz'),
(6, 'Валидация писем', 'emailverification');

CREATE TABLE IF NOT EXISTS `{PREFIX}el_subscriber` (
  `id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `hash` varchar(128) NOT NULL DEFAULT '',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '1',
  `comment` text,
  `valid` tinyint(4) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=292 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `{PREFIX}el_templates` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `subject` varchar(128) NOT NULL,
  `template` text NOT NULL,
  `count` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

INSERT INTO `{PREFIX}el_templates` (`id`, `name`, `subject`, `template`, `count`) VALUES
(0, 'Шаблон письма с новостям', '', '<link href=\"https://fonts.googleapis.com/css?family=Montserrat&display=swap\" rel=\"stylesheet\">\r\n<style>\r\n *{font-family: \'Montserrat\', sans-serif;}\r\n  h2{font-size:20px; line-height:1;}\r\n  p{font-size:14px; line-height:1;}\r\n</style>\r\n<div style=\"padding:0; margin:0; background:#fafafa; text-align:center; padding:15px;\">\r\n  <div style=\"padding:15px; background-color:white;  border: 0; border-radius: 10px; box-shadow: 0 0 0.3rem 0 rgba(0, 0, 0, .1);\">    \r\n    <div><img src=\"[(site_url)]assets/images/logo.png\" /></div>\r\n  	<h2>[+subject+]</h2>\r\n    \r\n	[+content+]\r\n    \r\n    <h2>Наши новости</h2>\r\n    [[DocLister? \r\n    &parents=`9` \r\n    &odeBy=`id desc`\r\n    &urlScheme=`full`\r\n    &summary=`notags,len:400`\r\n    &tpl=`@CODE: <h3>[+pagetitle+]</h3><p>[+summary+]</p><a href=\"[+url+]\" style=\"    color: #fff;background-color: #5cb85c;\r\n     text-decoration:none; padding:5px; boder-bottom:2px solid #56ac56;\">подробнее &rarr;</a>`\r\n    &display=`3`]]\r\n    \r\n	<p style=\"padding:10px; background:#fafafa;\">Для отписки перейдите по <a href=\"[+unscribe_link+]\">этой ссылке</a></p>\r\n    \r\n  </div>\r\n</div>', 0),
(1, 'Подтверждение регистрации', 'Подтверждение регистрации', '<link href=\"https://fonts.googleapis.com/css?family=Montserrat&display=swap\" rel=\"stylesheet\">\r\n<style>\r\n *{font-family: \'Montserrat\', sans-serif;}\r\n  h2{font-size:20px; line-height:1;}\r\n  p{font-size:14px; line-height:1;}\r\n</style>\r\n<div style=\"padding:0; margin:0; background:#fafafa; text-align:center; padding:15px;\">\r\n  <div style=\"padding:15px; background-color:white;  border: 0; border-radius: 10px; box-shadow: 0 0 0.3rem 0 rgba(0, 0, 0, .1);\">    \r\n    <div><img src=\"[(site_url)]assets/images/logo.png\" /></div>\r\n  	<h2>[+subject+]</h2>    \r\n	<p>Здравствуйте! Вы получили это письмо потому что подписались на рассылку на нашем сайте</p>\r\n	<p>[+content+]</p>\r\n    <p><i style=\"color:#fafafa;\">Если вы получили это письмо по ошибке, просто проигнорируйте его</i></p>\r\n  </div>\r\n</div>', 0),
(2, 'Пустой шаблон', '', '[+content+]    ', 0);

INSERT INTO `{PREFIX}system_eventnames` (`name`, `service`, `groupname`) VALUES
('OnELUserSubscription', 6, 'evoLetters'),
('OnELConfirmingUsersSubscription', 6, 'evoLetters'),
('OnELConfirmingUsersUnsubscribe', 6, 'evoLetters'),
('OnBeforeDistribution', 6, 'evoLetters'),
('OnAfterDistribution', 6, 'evoLetters');


ALTER TABLE `{PREFIX}el_letters` ADD PRIMARY KEY (`id`);

ALTER TABLE `{PREFIX}el_methods` ADD PRIMARY KEY (`id`);

ALTER TABLE `{PREFIX}el_subscriber` ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `{PREFIX}el_templates` ADD PRIMARY KEY (`id`);

ALTER TABLE `{PREFIX}el_letters` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;

ALTER TABLE `{PREFIX}el_methods` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;

ALTER TABLE `{PREFIX}el_subscriber` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=292;
