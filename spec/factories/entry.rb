FactoryBot.define do
  factory :entry, class: Entry do
    user_id { FactoryBot.build(:admin).id }
    kennzahl '1:1'
    japanische_umschrift 'chi {muchi}'
    deutsche_uebersetzung 'Torheit, Dummheit {Nicht-Torheit}'
  end

  factory :unprocessed_entry, parent: :entry do
    uebersetzung 'leer'
    status 'unbearbeitet'
  end

  factory :formatted_entry, parent: :entry do
    uebersetzung "<p>x0019_11 19:11 <span class=\"indexeintrag\"><span class=\"fachtermini\">Abaya</span> <span class=\"fachtermini\">阿婆耶</span> </span>C. Apoye, Transkription von s. p. Abhaya; als Mui, c. Wuwei (\u0084Ohne Furcht\u0093) &uuml;bersetzt.<span class=\"indexeintrag\"> Sohn des K&ouml;nigs von Magadha</span> (<span class=\"eigennamen\">Magada, c. Mojietuo</span>) Bimbisāra (Bimbashara, c. Binposuoluo), der Prinz \u0084Ohne-Furcht\u0093 genannt wurde. Von einem Nigraṇṭha-putra (Niken-ji-gedō; Anh&auml;nger des Jainismus) angestiftet, stellte er dem Buddha schwierige Fragen, wurde aber von diesem bekehrt und trat in den Orden ein. Lit.: Paramatthadīpanī (Theragāthā 26), Dhammapadatthakathā, Chang ahan jing&nbsp; Dīrghāgama 17, Za ahan jing&nbsp; Kṣudrakāgama 26, 27, Shizhu piposha lun 1. MD</p>\r\n"
    status 'formatiert'
  end

  factory :unformatted_entry, parent: :entry do
    uebersetzung "<p>x0007_01 7:1 Agon-shū 阿含宗 &bdquo;Agon Schule‟. Hauptsitz in Hirakawa-chō im Chiyoda-Bezirk von Tōkyō. Offizieller Name: Agon-shū-kannon-jikei-kai. Im Jahre 1955 (Shōwa 30) von Kiriyama Yasuo als Kannon-jikei-kai (&bdquo;↗Kannon-Barmherzigkeits-Gesellschaft‟) in Namamugi-chō im [Tsurumi]-Bezirk von Yokohama gegr&uuml;ndet, wurde sie 1978 (Shōwa 53) in Bezugnahme auf die Lehre des s. Āgama-sūtra (↗Agon-gyō) in Agon-shū umbenannt. Im darauffolgenden Jahr wurde ein hombu-dōjō (&bdquo;zentrale religi&ouml;se &Uuml;bungsst&auml;tte‟) in Tōkyō eingerichtet. Hauptgegenstand der Verehrung sind die drei Buddhas s. Śākyamuni (↗Shakamuni-butsu), Jundei Kannon (↗Kannon), und s. Mahāvairocana (↗Dainichi-nyorai), f&uuml;r die nach Lehrmeinung der Agon-shū der Satz &bdquo;Die drei Erscheinungsk&ouml;rper sind Eins‟ (sanshin-soku-ichi) (2↗busshin) gilt. Der Haupttempel der Schule befindet sich in Yamashina[-]kitakazan-ōmine[-chō] [im Higashiyama-Bezirk von] Kyōto. MIB Anmerkungen: 1 SBDJ hat f&auml;lschlich &bdquo;Namamugi-chō, Kanagawa-ku, Yokohama-shi&quot;. Namamugi-chō befindet sich in Tsurumi-ku. 2 Die Lesung &bdquo;Sanshin-soku-ichi‟ folgt dem Kōsetsu bukkyōgo daijiten (2001). SBDJ hat die Furigana-Lesung &bdquo;sanshin‟ auf Seite 1231, obere Spalte, im Fall von &bdquo;ichigetsu-sanshin‟, aber &bdquo;sanjin‟ auf Seite 1232, obere Spalte, im Fall von &bdquo;musa no sanjin‟. Der Eintrag &bdquo;sanshin/sanjin‟ unter &bdquo;busshin, 4‟ auf Seite 1231, mittlere Spalte, ist ohne Furigana-Lesung. Das Bukkyō-tetsugaku-daijiten, Mochizuki, Kokugo-daijiten, und Morohashi geben als Lesung &bdquo;sanjin-soku-ichi‟ bzw. &bdquo;sanjin‟ an. Die Lesung w&auml;re mit anderen Lemmata abzustimmen. 3 SBDJ hat f&auml;lschlich &bdquo;Yamashina-ku‟. Richtig ist: Yamashina-kitakazan-ōmine-chō, Higashiyama-ku.</p>"
    status 'unformatiert'
  end

  factory :deprecated_syntax_entry, parent: :entry do
    uebersetzung "x0290_01\n   \n\n\nKusharon-ki, Ju she lun ji   \n290:1\n30 Fasz. Auch \\C\\ Ju she lun guang ji\\\noder einfach \\C\\ Guang ji\\ genannt. Vefasst von \\C\\ Jin Guang\\ der Tang-Dynastie.\nEntstehungsjahr unklar. Kommentarwerk zum \\C\\ Ju she lun\\ (--> Kusharon),\ndas von \\C\\ Xuan Zang\\ (--> Genjô) übersetzt wurde. Der Verfasser\nwar ein Schüler von Xuan Zang ( 602-646). Zusammen mit den Kommentaren\nder anderen Schüler \\C\\ Shen Tai\\ und \\C\\ Fa Bao\\ wird er als einer\nder \u0084drei großen Kommentare zum Ju she lun\u0093 bezeichnet.\nEs ist eine Besonderheit dieses Werkes,\ndaß es in der Absicht geschrieben wurde, einen von Xuan Zang persönlich\nautorisierten, offiziellen Kommentar zu erstellen, unter Betonung der Überlieferung\nstellte er alle Arten von Interpretationen nebeneinander und fügte\nden vielen Ausführungen keine Beurteilungen hinzu. Als maßgebliches\nKommentarwerk zum Ju she lun  ist es von jeher mit Hochachtung betrachtet\nworden.\nQuellen: (  ) 41, Lun shu bu 1-5;\nDrucke: Ausgabe Genroku 15 (1702); Ausgabe Meiji 21 (1888).\nES\n \n \n \n "
    status 'Code veraltet'
  end

  factory :unprocessed_and_deprecated_entry, parent: :entry do
   uebersetzung "x0039_01\n\n\n\n\nN\n\nSBDJ 39 : 1\n\nLemma\n\n "
  end

  factory :published_entry, parent: :entry do
    freigeschaltet true
  end
end
