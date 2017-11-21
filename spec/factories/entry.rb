FactoryGirl.define do
  factory :entry, class: Entry do
    user_id { FactoryGirl.build(:admin).id }
    kennzahl '1:1'
    japanische_umschrift 'chi {muchi}'
    deutsche_uebersetzung 'Torheit, Dummheit {Nicht-Torheit}'
  end

  factory :blank_entry, parent: :entry do
    uebersetzung 'leer'
  end

  factory :formatted_entry, parent: :entry do
    uebersetzung "<p>x0019_11 19:11 <span class=\"indexeintrag\"><span class=\"fachtermini\">Abaya</span> <span class=\"fachtermini\">阿婆耶</span> </span>C. Apoye, Transkription von s. p. Abhaya; als Mui, c. Wuwei (\u0084Ohne Furcht\u0093) &uuml;bersetzt.<span class=\"indexeintrag\"> Sohn des K&ouml;nigs von Magadha</span> (<span class=\"eigennamen\">Magada, c. Mojietuo</span>) Bimbisāra (Bimbashara, c. Binposuoluo), der Prinz \u0084Ohne-Furcht\u0093 genannt wurde. Von einem Nigraṇṭha-putra (Niken-ji-gedō; Anh&auml;nger des Jainismus) angestiftet, stellte er dem Buddha schwierige Fragen, wurde aber von diesem bekehrt und trat in den Orden ein. Lit.: Paramatthadīpanī (Theragāthā 26), Dhammapadatthakathā, Chang ahan jing&nbsp; Dīrghāgama 17, Za ahan jing&nbsp; Kṣudrakāgama 26, 27, Shizhu piposha lun 1. MD</p>\r\n"
  end

  factory :unrevised_entry, parent: :entry do
    uebersetzung"x0273_04\n\n\n\n\nN\n\nSBDJ 273 : 4\n\nLemma\n\n"
  end

  factory :published_entry, parent: :entry do
    freigeschaltet true
  end
end
