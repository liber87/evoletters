//<?php
/**
 * evoLetters
 *
 * Подтверждение подписки/отписки
 *
 * @category    plugin
 * @internal    @events OnDocFormRender,OnDocFormSave,OnPageNotFound
 * @internal    @modx_category evoletters
 * @internal    @properties &succes_page=Страница удачной подписки;string;1 &succes_page_unscribe=Страница отписки;string;1 &method=Методы отправи;string;modxmail &succes_subscribe_subject=Тема успешной подписки;string;@CODE: Успешное подтверждение адреса на сайте [+site_name+] &succes_subscribe_text=Чанк с текстом письма об успешной подписке;string;@CODE: <p>Вы успешно подписались на сайте [+site_name+]. </p> &succes_unscribe_subject=Тема успешной отписки;string;@CODE: Вы отписались от рассылки с сайта [+site_name+] &succes_unscribe_text=Чанк с текстом письма об успешной подписке;string;@CODE: <p>Вы успешно отписались от рассылки с сайта [+site_name+].</p>
 * @internal    @disabled 0
 * @internal    @installset base
 */
require(MODX_BASE_PATH.'assets/modules/evoletters/evoletters.plugin.php');
