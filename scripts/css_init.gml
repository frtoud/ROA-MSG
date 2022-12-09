//css_init.gml

msg_error_active = false;
var nl = chr(0x0A);
msg_error_message = nl;
msg_error_timer = 0;

if (current_time % 3 == 0) && (room == asset_get("network_char_select"))
{
    msg_error_active = true;

    var rng_msgs = [];
    switch (get_local_setting(SET_LANGUAGE))
    {
        case 0: //EN
           rng_msgs = [
              "- Error -"+nl+"Your opponent doesn't have the same version of this item installed.", //4181
              "- Error -"+nl+"Replay data is corrupted.", //240
              "- Error -"+nl+"Item URL is incorrect.", //4182
              "- Error -"+nl+"No item is loaded.", //4183
              "- Error -"+nl+"There was an error making a connection.", //4222
              "- Error -"+nl+"Failed to log in to online service.",  //4221
              "- Error -"+nl+"No items to play online." //4187
           ];
        break;
        case 1: //JP
           rng_msgs = [
              "* エラー *"+nl+"このアイテムの バージョンが たいせんあいてと いっちしません。",
              "* エラー *"+nl+"リプレイデータが はそんしています。",
              "* エラー *"+nl+"アイテムの URLが ふせいです。",
              "* エラー *"+nl+"アイテムが よみこまれて いません。"
              "* エラー *"+nl+"せつぞくエラーが はっせいしました。",
              "* エラー *"+nl+"オンラインサービスに せつぞくできません。",
              "* エラー *"+nl+"オンラインで プレイできる アイテムが ありません。"
           ];
        break;
        case 2: //RU
           rng_msgs = [
              "- Ошибка -"+nl+"У вашего противника не установлена эта версия предмета.",
              "- Ошибка -"+nl+"Запись повреждена.",
              "- Ошибка -"+nl+"URL предмета неверен.",
              "- Ошибка -"+nl+"Предмет не загружен.",
              "- Ошибка -"+nl+"Подключение было сброшено.",
              "- Ошибка -"+nl+"Не удалось подключиться к серверу.",
              "- Ошибка -"+nl+"У вас нет синхронизированных предметов."
           ];
        break;
        default: //???
           rng_msgs = [
              "- Error -"+nl+"Your opponent doesn't have th3_)!$せんあいてと いっちしません。",
              " // (generic message for errors)"+nl+"220 = ",
              "VIEW FRIENDS LEADERBOARD",
              "@429",
              "* エラー *"+nl+"アイテムの URLが ふせいです。",
              "ZZWZZnZZgZZ"+nl+"ZZyZZiZZsZZnZZhZZuZZoZZeZZdZZeZZoZZ ZZiZZ ZZeZZoZZsZZpZZtZZ ZZ ZZeZZ ZZrZZhZZ ZZlZZbZZaZZoZZtZZaZZyZZeZZtZZ.",
              "- Error -"+nl+"Bad Response due to a Parse failure, missing field, etc.",
              "- Warning -"+nl+"Once deleted, the stage data cannot be recovered. Really delete the stage?"
           ];
        break;
    }

    var rng_msg = (current_time >> 3) % 12;
    if (rng_msg >= array_length(rng_msgs)) rng_msg = 0;
    msg_error_message = rng_msgs[rng_msg];
    sound_play(asset_get("mfx_notice"));
}