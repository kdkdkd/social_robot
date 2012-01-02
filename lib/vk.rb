require 'mechanize'
require 'nokogiri'
require 'json'

module Vkontakte

	@@countries = {"\u0423\u043A\u0440\u0430\u0438\u043D\u0430"=>2, "\u0410\u0432\u0441\u0442\u0440\u0430\u043B\u0438\u044F"=>19, "\u0410\u0432\u0441\u0442\u0440\u0438\u044F"=>20, "\u0410\u0437\u0435\u0440\u0431\u0430\u0439\u0434\u0436\u0430\u043D"=>5, "\u0410\u043B\u0431\u0430\u043D\u0438\u044F"=>21, "\u0410\u043B\u0436\u0438\u0440"=>22, "\u0410\u043C\u0435\u0440\u0438\u043A\u0430\u043D\u0441\u043A\u043E\u0435 \u0421\u0430\u043C\u043E\u0430"=>23, "\u0410\u043D\u0433\u0438\u043B\u044C\u044F"=>24, "\u0410\u043D\u0433\u043E\u043B\u0430"=>25, "\u0410\u043D\u0434\u043E\u0440\u0440\u0430"=>26, "\u0410\u043D\u0442\u0438\u0433\u0443\u0430 \u0438 \u0411\u0430\u0440\u0431\u0443\u0434\u0430"=>27, "\u0410\u0440\u0433\u0435\u043D\u0442\u0438\u043D\u0430"=>28, "\u0410\u0440\u043C\u0435\u043D\u0438\u044F"=>6, "\u0410\u0440\u0443\u0431\u0430"=>29, "\u0410\u0444\u0433\u0430\u043D\u0438\u0441\u0442\u0430\u043D"=>30, "\u0411\u0430\u0433\u0430\u043C\u044B"=>31, "\u0411\u0430\u043D\u0433\u043B\u0430\u0434\u0435\u0448"=>32, "\u0411\u0430\u0440\u0431\u0430\u0434\u043E\u0441"=>33, "\u0411\u0430\u0445\u0440\u0435\u0439\u043D"=>34, "\u0411\u0435\u043B\u0430\u0440\u0443\u0441\u044C"=>3, "\u0411\u0435\u043B\u0438\u0437"=>35, "\u0411\u0435\u043B\u044C\u0433\u0438\u044F"=>36, "\u0411\u0435\u043D\u0438\u043D"=>37, "\u0411\u0435\u0440\u043C\u0443\u0434\u044B"=>38, "\u0411\u043E\u043B\u0433\u0430\u0440\u0438\u044F"=>39, "\u0411\u043E\u043B\u0438\u0432\u0438\u044F"=>40, "\u0411\u043E\u0441\u043D\u0438\u044F \u0438 \u0413\u0435\u0440\u0446\u0435\u0433\u043E\u0432\u0438\u043D\u0430"=>41, "\u0411\u043E\u0442\u0441\u0432\u0430\u043D\u0430"=>42, "\u0411\u0440\u0430\u0437\u0438\u043B\u0438\u044F"=>43, "\u0411\u0440\u0443\u043D\u0435\u0439-\u0414\u0430\u0440\u0443\u0441\u0441\u0430\u043B\u0430\u043C"=>44, "\u0411\u0443\u0440\u043A\u0438\u043D\u0430-\u0424\u0430\u0441\u043E"=>45, "\u0411\u0443\u0440\u0443\u043D\u0434\u0438"=>46, "\u0411\u0443\u0442\u0430\u043D"=>47, "\u0412\u0430\u043D\u0443\u0430\u0442\u0443"=>48, "\u0412\u0435\u043B\u0438\u043A\u043E\u0431\u0440\u0438\u0442\u0430\u043D\u0438\u044F"=>49, "\u0412\u0435\u043D\u0433\u0440\u0438\u044F"=>50, "\u0412\u0435\u043D\u0435\u0441\u0443\u044D\u043B\u0430"=>51, "\u0412\u0438\u0440\u0433\u0438\u043D\u0441\u043A\u0438\u0435 \u043E\u0441\u0442\u0440\u043E\u0432\u0430, \u0411\u0440\u0438\u0442\u0430\u043D\u0441\u043A\u0438\u0435"=>52, "\u0412\u0438\u0440\u0433\u0438\u043D\u0441\u043A\u0438\u0435 \u043E\u0441\u0442\u0440\u043E\u0432\u0430, \u0421\u0428\u0410"=>53, "\u0412\u043E\u0441\u0442\u043E\u0447\u043D\u044B\u0439 \u0422\u0438\u043C\u043E\u0440"=>54, "\u0412\u044C\u0435\u0442\u043D\u0430\u043C"=>55, "\u0413\u0430\u0431\u043E\u043D"=>56, "\u0413\u0430\u0438\u0442\u0438"=>57, "\u0413\u0430\u0439\u0430\u043D\u0430"=>58, "\u0413\u0430\u043C\u0431\u0438\u044F"=>59, "\u0413\u0430\u043D\u0430"=>60, "\u0413\u0432\u0430\u0434\u0435\u043B\u0443\u043F\u0430"=>61, "\u0413\u0432\u0430\u0442\u0435\u043C\u0430\u043B\u0430"=>62, "\u0413\u0432\u0438\u043D\u0435\u044F"=>63, "\u0413\u0432\u0438\u043D\u0435\u044F-\u0411\u0438\u0441\u0430\u0443"=>64, "\u0413\u0435\u0440\u043C\u0430\u043D\u0438\u044F"=>65, "\u0413\u0438\u0431\u0440\u0430\u043B\u0442\u0430\u0440"=>66, "\u0413\u043E\u043D\u0434\u0443\u0440\u0430\u0441"=>67, "\u0413\u043E\u043D\u043A\u043E\u043D\u0433"=>68, "\u0413\u0440\u0435\u043D\u0430\u0434\u0430"=>69, "\u0413\u0440\u0435\u043D\u043B\u0430\u043D\u0434\u0438\u044F"=>70, "\u0413\u0440\u0435\u0446\u0438\u044F"=>71, "\u0413\u0440\u0443\u0437\u0438\u044F"=>7, "\u0413\u0443\u0430\u043C"=>72, "\u0414\u0430\u043D\u0438\u044F"=>73, "\u0414\u0436\u0438\u0431\u0443\u0442\u0438"=>231, "\u0414\u043E\u043C\u0438\u043D\u0438\u043A\u0430"=>74, "\u0414\u043E\u043C\u0438\u043D\u0438\u043A\u0430\u043D\u0441\u043A\u0430\u044F \u0420\u0435\u0441\u043F\u0443\u0431\u043B\u0438\u043A\u0430"=>75, "\u0415\u0433\u0438\u043F\u0435\u0442"=>76, "\u0417\u0430\u043C\u0431\u0438\u044F"=>77, "\u0417\u0430\u043F\u0430\u0434\u043D\u0430\u044F \u0421\u0430\u0445\u0430\u0440\u0430"=>78, "\u0417\u0438\u043C\u0431\u0430\u0431\u0432\u0435"=>79, "\u0418\u0437\u0440\u0430\u0438\u043B\u044C"=>8, "\u0418\u043D\u0434\u0438\u044F"=>80, "\u0418\u043D\u0434\u043E\u043D\u0435\u0437\u0438\u044F"=>81, "\u0418\u043E\u0440\u0434\u0430\u043D\u0438\u044F"=>82, "\u0418\u0440\u0430\u043A"=>83, "\u0418\u0440\u0430\u043D"=>84, "\u0418\u0440\u043B\u0430\u043D\u0434\u0438\u044F"=>85, "\u0418\u0441\u043B\u0430\u043D\u0434\u0438\u044F"=>86, "\u0418\u0441\u043F\u0430\u043D\u0438\u044F"=>87, "\u0418\u0442\u0430\u043B\u0438\u044F"=>88, "\u0419\u0435\u043C\u0435\u043D"=>89, "\u041A\u0430\u0431\u043E-\u0412\u0435\u0440\u0434\u0435"=>90, "\u041A\u0430\u0437\u0430\u0445\u0441\u0442\u0430\u043D"=>4, "\u041A\u0430\u043C\u0431\u043E\u0434\u0436\u0430"=>91, "\u041A\u0430\u043C\u0435\u0440\u0443\u043D"=>92, "\u041A\u0430\u043D\u0430\u0434\u0430"=>10, "\u041A\u0430\u0442\u0430\u0440"=>93, "\u041A\u0435\u043D\u0438\u044F"=>94, "\u041A\u0438\u043F\u0440"=>95, "\u041A\u0438\u0440\u0438\u0431\u0430\u0442\u0438"=>96, "\u041A\u0438\u0442\u0430\u0439"=>97, "\u041A\u043E\u043B\u0443\u043C\u0431\u0438\u044F"=>98, "\u041A\u043E\u043C\u043E\u0440\u044B"=>99, "\u041A\u043E\u043D\u0433\u043E"=>100, "\u041A\u043E\u043D\u0433\u043E, \u0434\u0435\u043C\u043E\u043A\u0440\u0430\u0442\u0438\u0447\u0435\u0441\u043A\u0430\u044F \u0440\u0435\u0441\u043F\u0443\u0431\u043B\u0438\u043A\u0430"=>101, "\u041A\u043E\u0441\u0442\u0430-\u0420\u0438\u043A\u0430"=>102, "\u041A\u043E\u0442 \u0434`\u0418\u0432\u0443\u0430\u0440"=>103, "\u041A\u0443\u0431\u0430"=>104, "\u041A\u0443\u0432\u0435\u0439\u0442"=>105, "\u041A\u044B\u0440\u0433\u044B\u0437\u0441\u0442\u0430\u043D"=>11, "\u041B\u0430\u043E\u0441"=>106, "\u041B\u0430\u0442\u0432\u0438\u044F"=>12, "\u041B\u0435\u0441\u043E\u0442\u043E"=>107, "\u041B\u0438\u0431\u0435\u0440\u0438\u044F"=>108, "\u041B\u0438\u0432\u0430\u043D"=>109, "\u041B\u0438\u0432\u0438\u0439\u0441\u043A\u0430\u044F \u0410\u0440\u0430\u0431\u0441\u043A\u0430\u044F \u0414\u0436\u0430\u043C\u0430\u0445\u0438\u0440\u0438\u044F"=>110, "\u041B\u0438\u0442\u0432\u0430"=>13, "\u041B\u0438\u0445\u0442\u0435\u043D\u0448\u0442\u0435\u0439\u043D"=>111, "\u041B\u044E\u043A\u0441\u0435\u043C\u0431\u0443\u0440\u0433"=>112, "\u041C\u0430\u0432\u0440\u0438\u043A\u0438\u0439"=>113, "\u041C\u0430\u0432\u0440\u0438\u0442\u0430\u043D\u0438\u044F"=>114, "\u041C\u0430\u0434\u0430\u0433\u0430\u0441\u043A\u0430\u0440"=>115, "\u041C\u0430\u043A\u0430\u043E"=>116, "\u041C\u0430\u043A\u0435\u0434\u043E\u043D\u0438\u044F"=>117, "\u041C\u0430\u043B\u0430\u0432\u0438"=>118, "\u041C\u0430\u043B\u0430\u0439\u0437\u0438\u044F"=>119, "\u041C\u0430\u043B\u0438"=>120, "\u041C\u0430\u043B\u044C\u0434\u0438\u0432\u044B"=>121, "\u041C\u0430\u043B\u044C\u0442\u0430"=>122, "\u041C\u0430\u0440\u043E\u043A\u043A\u043E"=>123, "\u041C\u0430\u0440\u0442\u0438\u043D\u0438\u043A\u0430"=>124, "\u041C\u0430\u0440\u0448\u0430\u043B\u043B\u043E\u0432\u044B \u041E\u0441\u0442\u0440\u043E\u0432\u0430"=>125, "\u041C\u0435\u043A\u0441\u0438\u043A\u0430"=>126, "\u041C\u0438\u043A\u0440\u043E\u043D\u0435\u0437\u0438\u044F, \u0444\u0435\u0434\u0435\u0440\u0430\u0442\u0438\u0432\u043D\u044B\u0435 \u0448\u0442\u0430\u0442\u044B"=>127, "\u041C\u043E\u0437\u0430\u043C\u0431\u0438\u043A"=>128, "\u041C\u043E\u043B\u0434\u043E\u0432\u0430"=>15, "\u041C\u043E\u043D\u0430\u043A\u043E"=>129, "\u041C\u043E\u043D\u0433\u043E\u043B\u0438\u044F"=>130, "\u041C\u043E\u043D\u0442\u0441\u0435\u0440\u0440\u0430\u0442"=>131, "\u041C\u044C\u044F\u043D\u043C\u0430"=>132, "\u041D\u0430\u043C\u0438\u0431\u0438\u044F"=>133, "\u041D\u0430\u0443\u0440\u0443"=>134, "\u041D\u0435\u043F\u0430\u043B"=>135, "\u041D\u0438\u0433\u0435\u0440"=>136, "\u041D\u0438\u0433\u0435\u0440\u0438\u044F"=>137, "\u041D\u0438\u0434\u0435\u0440\u043B\u0430\u043D\u0434\u0441\u043A\u0438\u0435 \u0410\u043D\u0442\u0438\u043B\u044B"=>138, "\u041D\u0438\u0434\u0435\u0440\u043B\u0430\u043D\u0434\u044B"=>139, "\u041D\u0438\u043A\u0430\u0440\u0430\u0433\u0443\u0430"=>140, "\u041D\u0438\u0443\u044D"=>141, "\u041D\u043E\u0432\u0430\u044F \u0417\u0435\u043B\u0430\u043D\u0434\u0438\u044F"=>142, "\u041D\u043E\u0432\u0430\u044F \u041A\u0430\u043B\u0435\u0434\u043E\u043D\u0438\u044F"=>143, "\u041D\u043E\u0440\u0432\u0435\u0433\u0438\u044F"=>144, "\u041E\u0431\u044A\u0435\u0434\u0438\u043D\u0435\u043D\u043D\u044B\u0435 \u0410\u0440\u0430\u0431\u0441\u043A\u0438\u0435 \u042D\u043C\u0438\u0440\u0430\u0442\u044B"=>145, "\u041E\u043C\u0430\u043D"=>146, "\u041E\u0441\u0442\u0440\u043E\u0432 \u041C\u044D\u043D"=>147, "\u041E\u0441\u0442\u0440\u043E\u0432 \u041D\u043E\u0440\u0444\u043E\u043B\u043A"=>148, "\u041E\u0441\u0442\u0440\u043E\u0432\u0430 \u041A\u0430\u0439\u043C\u0430\u043D"=>149, "\u041E\u0441\u0442\u0440\u043E\u0432\u0430 \u041A\u0443\u043A\u0430"=>150, "\u041E\u0441\u0442\u0440\u043E\u0432\u0430 \u0422\u0435\u0440\u043A\u0441 \u0438 \u041A\u0430\u0439\u043A\u043E\u0441"=>151, "\u041F\u0430\u043A\u0438\u0441\u0442\u0430\u043D"=>152, "\u041F\u0430\u043B\u0430\u0443"=>153, "\u041F\u0430\u043B\u0435\u0441\u0442\u0438\u043D\u0441\u043A\u0430\u044F \u0430\u0432\u0442\u043E\u043D\u043E\u043C\u0438\u044F"=>154, "\u041F\u0430\u043D\u0430\u043C\u0430"=>155, "\u041F\u0430\u043F\u0443\u0430 - \u041D\u043E\u0432\u0430\u044F \u0413\u0432\u0438\u043D\u0435\u044F"=>156, "\u041F\u0430\u0440\u0430\u0433\u0432\u0430\u0439"=>157, "\u041F\u0435\u0440\u0443"=>158, "\u041F\u0438\u0442\u043A\u0435\u0440\u043D"=>159, "\u041F\u043E\u043B\u044C\u0448\u0430"=>160, "\u041F\u043E\u0440\u0442\u0443\u0433\u0430\u043B\u0438\u044F"=>161, "\u041F\u0443\u044D\u0440\u0442\u043E-\u0420\u0438\u043A\u043E"=>162, "\u0420\u0435\u044E\u043D\u044C\u043E\u043D"=>163, "\u0420\u043E\u0441\u0441\u0438\u044F"=>1, "\u0420\u0443\u0430\u043D\u0434\u0430"=>164, "\u0420\u0443\u043C\u044B\u043D\u0438\u044F"=>165, "\u0421\u0428\u0410"=>9, "\u0421\u0430\u043B\u044C\u0432\u0430\u0434\u043E\u0440"=>166, "\u0421\u0430\u043C\u043E\u0430"=>167, "\u0421\u0430\u043D-\u041C\u0430\u0440\u0438\u043D\u043E"=>168, "\u0421\u0430\u043D-\u0422\u043E\u043C\u0435 \u0438 \u041F\u0440\u0438\u043D\u0441\u0438\u043F\u0438"=>169, "\u0421\u0430\u0443\u0434\u043E\u0432\u0441\u043A\u0430\u044F \u0410\u0440\u0430\u0432\u0438\u044F"=>170, "\u0421\u0432\u0430\u0437\u0438\u043B\u0435\u043D\u0434"=>171, "\u0421\u0432\u044F\u0442\u0430\u044F \u0415\u043B\u0435\u043D\u0430"=>172, "\u0421\u0435\u0432\u0435\u0440\u043D\u0430\u044F \u041A\u043E\u0440\u0435\u044F"=>173, "\u0421\u0435\u0432\u0435\u0440\u043D\u044B\u0435 \u041C\u0430\u0440\u0438\u0430\u043D\u0441\u043A\u0438\u0435 \u043E\u0441\u0442\u0440\u043E\u0432\u0430"=>174, "\u0421\u0435\u0439\u0448\u0435\u043B\u044B"=>175, "\u0421\u0435\u043D\u0435\u0433\u0430\u043B"=>176, "\u0421\u0435\u043D\u0442-\u0412\u0438\u043D\u0441\u0435\u043D\u0442"=>177, "\u0421\u0435\u043D\u0442-\u041A\u0438\u0442\u0441 \u0438 \u041D\u0435\u0432\u0438\u0441"=>178, "\u0421\u0435\u043D\u0442-\u041B\u044E\u0441\u0438\u044F"=>179, "\u0421\u0435\u043D\u0442-\u041F\u044C\u0435\u0440 \u0438 \u041C\u0438\u043A\u0435\u043B\u043E\u043D"=>180, "\u0421\u0435\u0440\u0431\u0438\u044F"=>181, "\u0421\u0438\u043D\u0433\u0430\u043F\u0443\u0440"=>182, "\u0421\u0438\u0440\u0438\u0439\u0441\u043A\u0430\u044F \u0410\u0440\u0430\u0431\u0441\u043A\u0430\u044F \u0420\u0435\u0441\u043F\u0443\u0431\u043B\u0438\u043A\u0430"=>183, "\u0421\u043B\u043E\u0432\u0430\u043A\u0438\u044F"=>184, "\u0421\u043B\u043E\u0432\u0435\u043D\u0438\u044F"=>185, "\u0421\u043E\u043B\u043E\u043C\u043E\u043D\u043E\u0432\u044B \u041E\u0441\u0442\u0440\u043E\u0432\u0430"=>186, "\u0421\u043E\u043C\u0430\u043B\u0438"=>187, "\u0421\u0443\u0434\u0430\u043D"=>188, "\u0421\u0443\u0440\u0438\u043D\u0430\u043C"=>189, "\u0421\u044C\u0435\u0440\u0440\u0430-\u041B\u0435\u043E\u043D\u0435"=>190, "\u0422\u0430\u0434\u0436\u0438\u043A\u0438\u0441\u0442\u0430\u043D"=>16, "\u0422\u0430\u0438\u043B\u0430\u043D\u0434"=>191, "\u0422\u0430\u0439\u0432\u0430\u043D\u044C"=>192, "\u0422\u0430\u043D\u0437\u0430\u043D\u0438\u044F"=>193, "\u0422\u043E\u0433\u043E"=>194, "\u0422\u043E\u043A\u0435\u043B\u0430\u0443"=>195, "\u0422\u043E\u043D\u0433\u0430"=>196, "\u0422\u0440\u0438\u043D\u0438\u0434\u0430\u0434 \u0438 \u0422\u043E\u0431\u0430\u0433\u043E"=>197, "\u0422\u0443\u0432\u0430\u043B\u0443"=>198, "\u0422\u0443\u043D\u0438\u0441"=>199, "\u0422\u0443\u0440\u043A\u043C\u0435\u043D\u0438\u044F"=>17, "\u0422\u0443\u0440\u0446\u0438\u044F"=>200, "\u0423\u0433\u0430\u043D\u0434\u0430"=>201, "\u0423\u0437\u0431\u0435\u043A\u0438\u0441\u0442\u0430\u043D"=>18, "\u0423\u043E\u043B\u043B\u0438\u0441 \u0438 \u0424\u0443\u0442\u0443\u043D\u0430"=>202, "\u0423\u0440\u0443\u0433\u0432\u0430\u0439"=>203, "\u0424\u0430\u0440\u0435\u0440\u0441\u043A\u0438\u0435 \u043E\u0441\u0442\u0440\u043E\u0432\u0430"=>204, "\u0424\u0438\u0434\u0436\u0438"=>205, "\u0424\u0438\u043B\u0438\u043F\u043F\u0438\u043D\u044B"=>206, "\u0424\u0438\u043D\u043B\u044F\u043D\u0434\u0438\u044F"=>207, "\u0424\u043E\u043B\u043A\u043B\u0435\u043D\u0434\u0441\u043A\u0438\u0435 \u043E\u0441\u0442\u0440\u043E\u0432\u0430"=>208, "\u0424\u0440\u0430\u043D\u0446\u0438\u044F"=>209, "\u0424\u0440\u0430\u043D\u0446\u0443\u0437\u0441\u043A\u0430\u044F \u0413\u0432\u0438\u0430\u043D\u0430"=>210, "\u0424\u0440\u0430\u043D\u0446\u0443\u0437\u0441\u043A\u0430\u044F \u041F\u043E\u043B\u0438\u043D\u0435\u0437\u0438\u044F"=>211, "\u0425\u043E\u0440\u0432\u0430\u0442\u0438\u044F"=>212, "\u0426\u0435\u043D\u0442\u0440\u0430\u043B\u044C\u043D\u043E-\u0410\u0444\u0440\u0438\u043A\u0430\u043D\u0441\u043A\u0430\u044F \u0420\u0435\u0441\u043F\u0443\u0431\u043B\u0438\u043A\u0430"=>213, "\u0427\u0430\u0434"=>214, "\u0427\u0435\u0440\u043D\u043E\u0433\u043E\u0440\u0438\u044F"=>230, "\u0427\u0435\u0445\u0438\u044F"=>215, "\u0427\u0438\u043B\u0438"=>216, "\u0428\u0432\u0435\u0439\u0446\u0430\u0440\u0438\u044F"=>217, "\u0428\u0432\u0435\u0446\u0438\u044F"=>218, "\u0428\u043F\u0438\u0446\u0431\u0435\u0440\u0433\u0435\u043D \u0438 \u042F\u043D \u041C\u0430\u0439\u0435\u043D"=>219, "\u0428\u0440\u0438-\u041B\u0430\u043D\u043A\u0430"=>220, "\u042D\u043A\u0432\u0430\u0434\u043E\u0440"=>221, "\u042D\u043A\u0432\u0430\u0442\u043E\u0440\u0438\u0430\u043B\u044C\u043D\u0430\u044F \u0413\u0432\u0438\u043D\u0435\u044F"=>222, "\u042D\u0440\u0438\u0442\u0440\u0435\u044F"=>223, "\u042D\u0441\u0442\u043E\u043D\u0438\u044F"=>14, "\u042D\u0444\u0438\u043E\u043F\u0438\u044F"=>224, "\u042E\u0436\u043D\u0430\u044F \u041A\u043E\u0440\u0435\u044F"=>226, "\u042E\u0436\u043D\u043E-\u0410\u0444\u0440\u0438\u043A\u0430\u043D\u0441\u043A\u0430\u044F \u0420\u0435\u0441\u043F\u0443\u0431\u043B\u0438\u043A\u0430"=>227, "\u042F\u043C\u0430\u0439\u043A\u0430"=>228, "\u042F\u043F\u043E\u043D\u0438\u044F"=>229}


	#Output message from system
	def log(*args, &block)
		@@log_block = block if block
		@@log_block.call args[0] if args.length>0 && @@log_block
	end
	
	
	#which page is to refer all reqests
	@@vkontakte_location_var = "http://vkontakte.ru"
	
	#change page which refers all requests
	def force_location(location = "http://vkontakte.ru")
		@@vkontakte_location_var = location
	end
	
	#get page which refers all requests
	def vkontakte_location
		@@vkontakte_location_var
	end
	
	
	#Ask user to resolve captcha
	def ask_captcha(*args, &block)
		@@ask_captcha_block = block if block
		@@ask_captcha_block.call args[0] if args.length>0 && @@ask_captcha_block
	end
	
	#Ask user to login
	def ask_login(*args, &block)
		if block
			@@ask_login_block = block 
		else
			@@ask_login_block.call if @@ask_login_block
		end
	end
	
	
	#Ask user to login
	def ask_phone(*args, &block)
		if block
			@@ask_phone_block = block 
		else
			@@ask_phone_block.call(*args) if @@ask_phone_block
		end
	end
	
	#Try to login in any way
	def forсe_login(connector,self_connect=nil)
		connect = nil
		if connector
			connect = connector.connect
		elsif !self_connect.nil?
			connect = self_connect
		else
			connect = Vkontakte::last_connect
		end
		unless connect && connect.login
			ask_login 
			connect = Vkontakte::last_connect
		end
		connect
	end
		
	
	@@application_directory = "."
	
	def application_directory=(value)
		@@application_directory = value
	end
	
	def application_directory
		@@application_directory
	end
	
	def loot_directory
		File.join(Vkontakte::application_directory,"loot")
	end
	
	def session_file
		File.join(Vkontakte::application_directory,"session","session.txt")
	end
	
	def convert_exe
		File.join(Vkontakte::application_directory,"magick","convert.exe")
	end
	
	def last_connect=(val)
		@@last_connect=val
	end
	
	def last_connect
		@@last_connect
	end
	
	@@last_connect = nil
	
	class Connect
		attr_reader :uid
		
		
		def cookie
			@cookie_login
		end
		
		def initialize(login = nil, password = nil)
			@agent = Mechanize.new { |agent|  agent.user_agent_alias = 'Mac Safari'	}
			@login = login
			@password = password
			Vkontakte::last_connect = self
		end
		
		#Restore cookie from file
		def restore_from_session
			begin
				cookie_value = IO.read(session_file)	
				@cookie_login = Mechanize::Cookie.new("remixsid", cookie_value)
				@cookie_login.domain = ".vkontakte.ru"
				@cookie_login.path = "/"
    			return true
			rescue
				return false
			end
		end
		
		#Check if connection is ok
		def check_login
			begin
				resp = get("/feed")
				id = User.get_id_by_response(resp)
				@uid = id
				return id
			rescue
				return false
			end
		end
		
		def ask_captcha_internal(captcha_sid)
			file_name = save(addr("/captcha.php?sid=#{captcha_sid}&s=1"),"captcha","#{captcha_sid}.jpg")
			file_name_png = file_name.gsub(".jpg",".png")
			command = "\"#{Vkontakte::convert_exe}\" \"#{file_name}\" \"#{file_name_png}\""
			system(command)
			captcha_key = ask_captcha(captcha_sid)
			File.delete file_name
			File.delete file_name_png
			captcha_key
		end
		
		
		
		#Save some file to loot folder
		def save(url,folder,filename)
			path = File.join(Vkontakte::loot_directory,folder)
			Dir::mkdir(path) unless File.exists?(path) && File.directory?(path)
			log "Downloading " + url
			filename = filename.gsub(/[\\\/\:\"\*\?\<\>\|]+/,'').gsub("\s","_")
			ext = File.extname(filename)
			basename = filename.chomp(ext)
			basename = basename[0..99] + "..." if basename.length>100
			res = File.join(path,basename + ext)
			@agent.get(url).save(res)
			res
		end
		
		#Make GET request
		def get(href)
			res = @agent.get(addr(href),[],nil,{'cookie' => @cookie_login}).body
			res.force_encoding("cp1251")
			res = res.encode("utf-8")
			res
		end
		
		#Fetch user page
		def get_user(id)
			if(@last_user_fetch_date)
				diff = Time.new - @last_user_fetch_date
				sleep(2.1 - diff) if(diff<2.1)
			end
			
			not_ok = true			
			sleep_time = 100
			while not_ok do
				addr_of_user = (id =~ /^\d+$/)?("/id" + id):("/" + id)
				res = get(addr_of_user)
				
				if(res.index('"post_hash"') || res.index('"profile_deleted_text"'))
					not_ok = false
				else
					sleep sleep_time
					sleep_time *= 10
				end
			end
			@last_user_fetch_date = Time.new
			res
		end
		
		
		#Add vkontakte.ru to address
		def addr(rel = "")
			if(rel.index("vkontakte.ru"))
				return rel
			else
				return vkontakte_location() + rel
			end
		end
		
		#Make POST request
		def post(href, params, skip_encoding = false)
			res = @agent.post(addr(href), params , 'cookie' => @cookie_login).body
			unless skip_encoding
				res.force_encoding("cp1251")
				res = res.encode("utf-8")
			end
			res
		end
		
		#Make POST request and resolve answer in special way
		def silent_post(href, params)
			resp_post = post(href, params)
			silent(resp_post)
    end

    def silent(resp_post)
			resp = resp_post.split("<!>").find{|str| str.start_with?('{"all":')}.gsub(/^\{\"all\"\:/,'').gsub(/}$/,'').gsub("\r","").gsub("\n","")
			eval("resp=#{resp}")
			resp
		end
		
		#Save cookie to file
		def save_cookie
			File.open(Vkontakte::session_file,"w"){|f|f<<@cookie_login.value}
		end
		
		#login with given login and password
		def login
			return true if @cookie_login
			log "Logging in..."
			@agent.get(addr("/")) do |login_page|
				login_result = login_page.form_with(:name => 'login') do |login|
					login.pass = @password
					login.email = @login
				 end.submit
				 

				 
				 
				 @agent.cookies.each do |cookie|
					@cookie_login = cookie if cookie.name == "remixsid"
				 end
				 if @cookie_login
				    
					id = check_login
					if(id)
						save_cookie
						log "Done"
						@uid = id
						return id
					else
						#need phone prove
						log "Failed"
						return false
					end
				 else
					log "Failed"
					return false
				 end
			end
		end
		
		
	end
	
	class Music
		attr_accessor :id,:name,:author,:link,:duration,:connect, :delete_hash
		
		def set(id,name,author,link,duration,connect)
			id_split = id.split("_")
			@user_id = id_split[0]
			@id = id_split[1]
			@name = name
			@connect = connect
			@link = link
			@duration = duration
			@author = author
			self
		end
		
		def uniq_id
			self.id + "_" + @user_id
		end
		
		def set_array(array,connect)
			set(array[0].to_s + "_" + array[1].to_s,array[6],array[5],array[2],array[4],connect)
			self
		end
		
		def to_s
			"#{@author} #{@name}(#{@id})"
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def download
			return false unless @connect.login
			@connect.save(@link,"music","#{@author}_#{@name}_#{id}.mp3")
		end
		
		def owner
			User.new.set(@user_id,nil,@connect)
		end
		
		
		def Music.all(q, connector=nil)
		  connect = forсe_login(connector)
			
			html = Nokogiri::HTML(connect.post('/al_search.php',{"al" => "1", "c[q]" => q, "c[section]" => "audio", "c[sort]" => "2"}).split("<!>")[6].gsub("<!-- ->->",""))
			res = []
			html.xpath("//table").to_a.each do |table|
				dur = table.xpath(".//div[@class='duration fl_r']")
				if(dur.length>0)
					res.push(Music.new.set(
						table.xpath(".//input[@type='hidden']/@id").text.scan(/audio_info(\d+\_\d+)/)[0][0],
						table.xpath(".//div[@class='audio_title_wrap']//span").find{|span| (!span["id"].nil?) && span["id"].start_with?("title")}.text,
						table.xpath(".//div[@class='audio_title_wrap']//a").first.text,
						table.xpath(".//input[@type='hidden']/@value").text.split(",")[0],
						dur.text,
						connect
					))
				end
			end
			res
		end
		
		def Music.one(q, connector=nil)
			Music.all(q, connector)[0]
		end
		
		def Music.upload(file, connector=nil)
			connect = forсe_login(connector)
			
			res_total = nil
			if(file.class.name == "Array")
				filenames = file
				many = true
				res_total = []
			else
				filenames = [file]
				many = false
				
            end
			
			filenames.each do |filename|
				#Asking for upload parameters and server
				a = connect.post('/audio',{"act" => "new_audio", "al" => "1", "gid" => "0"}).scan(/Upload\.init\(\s*([^\,]+)\s*\,\s*([^\,]+)\s*\,\s*(\{[^\}]*\})/)
				params = JSON.parse(a[0][2])
				params["ajx"] = "1"
				f = File.new(filename, "rb")
				params["file"] = f
				addr = a[0][1].gsub("\"",'').gsub("'",'')
				log "Uploading " + filename
				
				#Uploading music
				res = JSON.parse(connect.post(addr,params))
				f.close
				
				res["act"] = "done_add"
				res["al"] = "1"
				res["artist"] = CGI::unescape(res["artist"])
				res["title"] = CGI::unescape(res["title"])
				
				
				
				#Finishing action
				music_res = connect.post('/audio',res).scan(/\[[^\]]*\]/).find{|x| x.index("vkontakte.ru")}
				res_internal = Music.new.set_array(JSON.parse(music_res),connect)
				if many
					res_total.push(res_internal)
				else
					res_total = res_internal
				end
			end
			res_total
		end

    def remove
      return false unless @connect.login
      return false unless delete_hash
      log "Deleting music..."
      @connect.post('/audio',{'act' => 'delete_audio', 'aid' => id ,'al' => '1', 'hash' => delete_hash, 'oid' => @user_id, 'restore' => '1'})
    end
		
	end
	
	class Group
		attr_accessor :connect, :id
		
		def set(id,name=nil,connect=nil)
			@id = id.to_s
			@name = name

			@connect = (connect)?connect:Vkontakte::last_connect
			self
		end
		
		def name
			return @name if @name 
			info
			@name
		end
	
	  def to_s
			(@name)? "#{@name}(#{@id})" : "#{@id}"
		end
		
		def uniq_id
			id
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def info(connector=nil)
			connect = forсe_login(connector,@connect)
			log "Fetching info..."
			href = "/club#{id}"
			resp = connect.get(href)
			begin
				@group_hash = resp.scan(Regexp.new("#{id}\,\s*\'([^\']*)\'"))[0][0]
			rescue
				@group_hash = nil
			end
			
			@name = Nokogiri::HTML(resp).xpath("//title").text unless @name
		end
		
		def group_hash
			return @group_hash if @group_hash
			info
			@group_hash
		end
		
		def Group.parse(href,connector=nil)
			connect = forсe_login(connector)
			if(href.index("/club"))
				Group.new.set(href.split("/club").last,nil,connect)
			elsif (href.index("/event"))
				Group.new.set(href.split("/event").last,nil,connect)
			end
		end
		
		def enter(connector=nil)
			old_connect = @connect
			@connect = forсe_login(connector,@connect)
			return unless group_hash
			log "Entering group ..."
			connect.post('/al_groups.php',{"act" => "enter", "al" => "1", "gid" => id , "hash" => group_hash})
			@connect = old_connect
			
		end
		
		def leave(connector=nil)
			old_connect = @connect
			@connect = forсe_login(connector,@connect)
			return unless group_hash
			log "Leaving group ..."
				connect.post('/al_groups.php',{"act" => "enter", "context" => "_decline" ,"al" => "1", "gid" => id , "hash" => group_hash})
			  connect.post('/al_groups.php',{"act" => "leave", "al" => "1", "gid" => id , "hash" => group_hash})
      @connect = old_connect
		end
		
		
		def invite(user,connector=nil)
			old_connect = @connect
			@connect = forсe_login(connector,@connect)
			log "Inviting to group ..."
			
			invite_box = @connect.post('/al_page.php', {'act' => 'a_invite_box', 'al' => '1', 'gid' => id})
			
			invite_box.scan(/page\.inviteToGroup\(([^\)]*)\)/).each do |arg|
				args = arg[0].split(",").map{|x|x.strip}
				correct_args = args.find{|x| x = user.id}
				if(correct_args)
					hash = args.last.gsub("'",'')
					@connect.post('/al_page.php', {'act' => 'a_invite', 'al' => '1', 'gid' => id, "hash" => hash, "mid" => user.id}).scan("page.inviteToGroup\(([^\)]*)\)")
				end
			end
			
			@connect = old_connect
		end
	
	end
	

	class User
		attr_accessor :me, :connect
		
		def User.get_id_by_response(resp)
			resp.scan(/id\:\s*([^\,]*)\,/)[0][0]
		end
		
		
		def User.get_post_hash(resp)
			resp.scan(/\"post_hash\"\:\"([^\"]*)\"/)[0][0]
		end
		
		def id
			@id = @id.to_s
			return @id if @id =~ /^\d+$/
			info
			@id
		end
		
		def name
			return @name if @name
			info
			@name
		end
		
		def deleted
			return @deleted if @deleted == true || @deleted == false
			info
			@deleted
		end
		
		def post_hash
			return @post_hash if @post_hash
			info
			@post_hash
		end
		
		
		def friend_hash
			info
			@friend_hash
		end
		
		def set(id,name=nil,connect=nil)
			@id = id.to_s
			@name = name
			@connect = (connect)?connect:Vkontakte::last_connect;
			@me = false
			self
		end
		
		def User.id(id_set)
			res = User.new.set(id_set)
			res.connect = forсe_login(nil)
			res
		end
		
		def User.login(login,pass)
			User.new.login(login,pass)
		end
		
		#login with current login and password
		def login(login,pass)
			@connect = Connect.new(login,pass)
			@id = @connect.login
			return nil unless @id
			@me = true
			self
		end
		
		#login with cookie stored in session file
		def login_from_session()
			@connect = Connect.new
			return nil unless @connect.restore_from_session
			@id = @connect.check_login
			return nil unless @id
			@me = true
			self
		end

		def to_s
			(@name)? "#{@name}(#{@id})" : "#{@id}"
		end
		
		def uniq_id
			id
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end

		def friends
			return false unless @connect.login
			
			if(@me)
				log "List of my friends..."	
				friends_json = JSON.parse(@connect.post('/al_friends.php', {"act" => "pv_friends","al" => "1"}).gsub(/^.*\<\!json\>/,''))
				friends_json.map{|x,y| User.new.set(x.gsub('_',''),y[1],@connect)}
			else
				log "List of friends..."
				@connect.silent_post('/al_friends.php', {"act" => "load_friends_silent","al" => "1","id"=>@id,"gid"=>"0"}).map{|x| User.new.set(x[0],x[4],@connect)}
			end
		end
		
		def info
			return @info if @info
			return false unless @connect.login
			log "Fetching info ..."
			
			resp = @connect.get_user(@id.to_s)
			@id = User.get_id_by_response(resp) unless @id.to_s =~ /^\d+$/
			html = Nokogiri::HTML(resp)
			name_new = html.xpath("//title").text
			@name = name_new
			
			@deleted = html.xpath("//div[@class='profile_deleted']").length==1
			if @deleted
				@post_hash = nil
				@info = {}
				return
			end
			@post_hash = User.get_post_hash(resp)
			
			begin 
				@friend_hash = resp.scan(/toggleFriend\(this\,\s*\'([^\']*)\'/)[0][0]
			rescue
				@friend_hash = nil
			end
			
			hash = {"статус" => html.xpath("//div[@id='profile_current_info']").text}
			h1 = html.xpath("//div[@class='label fl_l']").map{|div| div.text}
			h2 = html.xpath("//div[@class='labeled fl_l']").map{|div| div.text}
			h1.each_with_index{|name,index| hash[name.chomp(":")] = h2[index]}
			@info = hash
		end
		
		def music
			return false unless @connect.login
			log "List of music..."
			q = {"act" => "load_audios_silent","al" => "1"}
			q["id"]=@id unless @me

      res = @connect.post('/audio', q )
      music_delete_hash = res.scan(/\"delete_hash\"\:\"([^\"]+)\"/)[0][0]
			@connect.silent(res).map{|x| m = Music.new.set_array(x,@connect);m .delete_hash=music_delete_hash; m}
		end
		
		def albums
			return false unless @connect.login
			log "List of albums ..."
			offset = 0
			total_res = []
			
			while true
			    
			
				hash_params = {"al" => "1", "offset" => offset.to_s, "part" => "1"}
				if(offset==0)
					xml = Nokogiri::HTML(@connect.get("/albums#{@id}"))
				else
					xml = Nokogiri::HTML(@connect.post("/albums#{@id}",hash_params).split("<!>").find{|x| x.index "<div"})
				end
				
				current_res = xml.xpath("//div[@class='name']/a").inject([]) do |array,a| 
					album_delete_hash = nil
					
					a.xpath("../..//a").each do |a_delete| 
						a_delete_onclick = a_delete["onclick"]
						if(a_delete_onclick && a_delete_onclick.index("photos.deleteAlbum"))
							album_delete_hash = a_delete_onclick.scan(/\'([^\']+)\'/)[1][0]
						end
					end
					array.push(Album.new.set(self,a["href"].scan(/_(\d+)/)[0][0],a.text,album_delete_hash,connect))
					array
				end
				break if current_res.length == 0
				total_res += current_res
				offset+=current_res.length
			end
			total_res
		end
		
		
		def post(msg,connector=nil)
			connect_old = @connect
			@connect = forсe_login(connector,@connect)
			log "Posting ..."
			captcha_sid = nil
			captcha_key = nil
			@post_hash = nil
            while true
				hash = {"act" => "post","al" => "1", "facebook_export" => "", "friends_only" => "", "hash" => post_hash, "message" => msg, "note_title" => "", "official" => "" , "status_export" => "", "to_id" => id, "type" => "all" }
				unless(captcha_key.nil?)
					hash["captcha_sid"] = captcha_sid
					hash["captcha_key"] = captcha_key
				end
				res = @connect.post('/al_wall.php', hash)
				if(res.index("<!json>"))
					html_text = res.split("<!>").find{|x| x.index('"post_table"')}
					return Post.parse_html(Nokogiri::HTML(html_text.gsub("<!-- ->->","")),self,@connect)
				else
					a = res.split("<!>")
					captcha_sid = a[a.length-2]
					captcha_key = @connect.ask_captcha_internal(captcha_sid)
				end
			end
			@connect = connect_old
		end
		
		def mail(message, title = "",connector=nil)
			connect = forсe_login(connector,@connect)
			log "Mailing ..."
			chas = connect.post('/al_mail.php', {"act" => "write_box", "al" => "1", "to" => id}).scan(/cur.decodehash\(\'([^\']*)\'/)[0][0]
			chas = (chas[chas.length - 5,5] + chas[4,chas.length - 12])
			chas.reverse!

			captcha_sid = nil
			captcha_key = nil
            while true
				hash = {"act" => "a_send","al" => "1", "ajax" => "1", "from" => "box", "chas" => chas, "message" => message, "title" => title, "media" => "" , "to_id" => id }
				unless(captcha_key.nil?)
					hash["captcha_sid"] = captcha_sid
					hash["captcha_key"] = captcha_key
				end
				res = connect.post('/al_mail.php', hash)
				if(res.index("<div"))
					break
				else
					a = res.split("<!>")
					captcha_sid = a[a.length-2]
					captcha_key = connect.ask_captcha_internal(captcha_sid)
				end
			end
		end
		
		def wall(size = 50)
			return false unless @connect.login
     		log "Reading wall ..."
			return wall_offset(size) if size == "all"
		    res_all = []
			index = 0
			while true do
				res = wall_offset(index.to_s)
				index += res.length
				break if res.length == 0 || res_all.length>=size.to_i
				res_all += res
			end
			return res_all
		end
		
		
		
		def wall_offset(offset = 0)
			if offset=="all"
				res_all = []
				index = 0
				while true do
					res = wall_offset(index.to_s)
					index += res.length
					break if res.length == 0
					res_all += res
				end
				return res_all
			end
		
			res_post = @connect.post("/wall#{id}",{"offset" => offset.to_s, "al" => "1","part"=>"1"})
			html_text = res_post.split("<!>").find{|x| x.index('"post_table"')}
			return [] unless html_text
			html = Nokogiri::HTML(html_text.gsub("<!-- ->->",""))
			
			
			
			res = []
			html.xpath("//table[@class='post_table']").each do |table|
				res.push Post.parse_html(table,self,@connect)
			end
			
			res

		end
		
		
		def invite(message=nil,connector=nil)
			connect_old = @connect
			@connect = forсe_login(connector,@connect)
			log "Inviting ..."

			fh = friend_hash
			
			
			
			captcha_sid = nil
			captcha_key = nil
            while true
				hash = {"act" => "add", "al" => "1", "from" => "profile", "hash" => fh, "mid" => id }
				unless(captcha_key.nil?)
					hash["captcha_sid"] = captcha_sid
					hash["captcha_key"] = captcha_key
				end
				res = @connect.post('/al_friends.php', hash)
				if(res.index("<div"))
					break
				else
					a = res.split("<!>")
					captcha_sid = a[a.length-2]
					captcha_key = @connect.ask_captcha_internal(captcha_sid)
				end
			end

			@connect.post('/al_friends.php', {"act" => "friend_tt", "al" => "1", "mid" => id})

			@connect.post('/al_friends.php', {"act" => "request_text", "al" => "1", "mid" => id,"hash" => fh, "message" => message}) if message
			
			
			@connect = connect_old
		end
		
		
		def uninvite(connector=nil)
			connect_old = @connect
			@connect = forсe_login(connector,@connect)
			log "Uninviting ..."
			@connect.post('/al_friends.php', {"act" => "remove", "al" => "1", "mid" => id, "hash" => friend_hash})
			@connect = connect_old
		end
		
		def User.all(query = '', size = 50, hash = {}, connector=nil)
			log "Searching users ..."
		    res_all = []
			index = 0
			while true do
				res = User.all_offset(query,index,hash,connector)
				index += res.length
				break if res.length == 0 || res_all.length>=size.to_i
				res_all += res
			end
			return res_all
		end
		
		def User.one(query = '', hash = {}, connector=nil)
			User.all_offset(query,0,hash,connector)[0]
		end
		
		
		def User.all_offset(query = '', offset = 0, hash = {}, connector=nil)
			connect = forсe_login(connector)
			return [] unless connect.login
			
			qhash = {'al' => '1', 'c[name]' => '0', 'c[q]' => query, 'c[section]' => 'people', 'offset' => offset.to_s}
			country_name = hash["Страна"]
			country = @@countries[country_name]
			
			qhash["c[country]"] = country if country
			city = hash["Город"]
			if(city && country)
					res_city = connect.post('/select_ajax.php',{"act" => "a_get_cities", "country" => country.to_s, "str" => city},true)
					city = res_city.scan(/\d+/)[0]
					qhash["c[city]"] = city if city
			end
			
			qhash["c[sex]"] = "2" if(hash["Пол"] == "Мужской")
			qhash["c[sex]"] = "1" if(hash["Пол"] == "Женский")
			
			qhash["c[online]"] = "1" if(hash["Онлайн"] == "Да")
			
			
			res = connect.post('/al_search.php',qhash)
			html_text = res.split("<!>").find{|x| x.index '<div'}
			return [] unless html_text
			html = Nokogiri::HTML(html_text)
			res = []
			html.xpath("//div[@class='info fl_l']").each do |human|
				a = human.xpath(".//a")[0]
				
				res.push(User.new.set(a["href"].gsub("/id","").gsub("/",""),a.text,connect))
			
			end
			res
			
			
		end
		
		
		def User.parse(href)
			if href.index("/id")
				id = href.split("/id")[1] 
			else
				id = href.split("/").last
			end
			User.id(id)
		end
		
		
		def groups
			return false unless @connect.login
			log "List of groups..."
			res = []
			JSON.parse(@connect.post('/al_groups.php', {"act" => "get_list", "al" => "1", "mid" => id, "tab" => "groups"}).split("<!>").find{|x| x.index("<!json>")}.gsub("<!json>","")).each do |el|
				 res.push Group.new.set(el[2].to_s,el[0],@connect)
			end
			res.uniq!
			res
		
		end
	end
	
	
	class Post
		attr_accessor :id, :user, :text, :delete_hash, :like_hash, :connect
		
		def set(user,id,text,delete_hash,like_hash,connect)
			@id = id
			@text = text
			@connect = connect
			@user = user
			@delete_hash = delete_hash
			@like_hash = like_hash
			self
		end
		
		def Post.parse_html(table,user,connect)
			
			id_of_post = table.to_s.scan(Regexp.new("#{user.id}\\_(\\d+)"))[0][0]

			delete_hash = table.to_s.scan(/wall\.deletePost[^\,]*\,\s*\'([^\']*)\'/)[0]
			delete_hash = (delete_hash)?delete_hash[0]:nil

			like_hash = table.to_s.scan(/wall\.like[^\,]*\,\s*\'([^\']*)\'/)[0]
			like_hash = (like_hash)?like_hash[0]:nil

			text_of_post = table.xpath(".//div[@id='wpt#{user.id}_#{id_of_post}']")
			text_of_post = (text_of_post.length>0)?(text_of_post[0].text):nil

			Post.new.set(user,id_of_post,text_of_post,delete_hash,like_hash,connect)
		
		end
		
		
		
		def uniq_id
			self.id + "_" + self.user.id
		end
		
		def ==(other_user)
			self.uniq_id == other_user.uniq_id
		end
		
		def hash
			self.id.hash
		end
		
		
		def like(connector=nil)
			connect = forсe_login(connector,@connect)
			return false unless connect.login
			return false unless like_hash
			log "Like post ..."
			res_post = connect.post("/like.php",{"act" => "a_do_like", "al" => "1","from"=>"wall_page","hash"=>like_hash,"object"=>"wall#{user.id}_#{id}","wall"=>"1"})
		end
		
		def unlike(connector=nil)
			connect = forсe_login(connector,@connect)
			return false unless connect.login
			return false unless like_hash
			log "Unlike post ..."
			res_post = connect.post("/like.php",{"act" => "a_do_unlike", "al" => "1","from"=>"wall_page","hash"=>like_hash,"object"=>"wall#{user.id}_#{id}","wall"=>"1"})
		end
		
		def remove
			return false unless @connect.login
			return false unless delete_hash
			log "Delete post ..."
			res_post = @connect.post("/al_wall.php",{"act" => "delete", "al" => "1","from"=>"wall","hash"=>delete_hash,"post"=>"#{user.id}_#{id}","root"=>"0"})
		end

		def to_s
			"#{text}(#{@id})"
		end
	end
	

	class Album
		attr_accessor :id, :user, :name, :connect, :delete_hash
		
		
		def Album.parse(href)
			id_complex = href.split("/album").last.split("_")
			user = User.id(id_complex.first)
			user.albums.find{|x| x.id == id_complex.last}
		end
		
		
		def set(user,id,name,delete_hash,connect)
			@id = id
			@name = name
			@connect = connect
			@user = user
			@delete_hash = delete_hash
			self
		end
		
		def to_s
			"#{name}(#{@id})"
		end
		
		def uniq_id
			self.id + "_" + self.user.id
		end
		
		def ==(other_user)
			self.uniq_id == other_user.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def Album.create(name, description="", connector=nil)
			connect = forсe_login(connector)
			
			log "Creating album ..."
			hash = connect.post('/al_photos.php',{"al" => "1", "act" => "new_album_box"}).scan(/hash\:\s*\'([^\']+)\'/)[0][0]
			res = connect.post('/al_photos.php',{"al" => "1", "act" => "new_album", "comm" => "0", "view" => "0", "only" => "false" , "oid" => connect.uid, "title" => name, "desc" => description, "hash" => hash })
			album_id = res.scan(/\_(\d+)/)[0][0]
			Album.new.set(User.new.set(connect.uid), album_id ,name,nil,connect)
		end
		
		
		def upload(file,description)
			return false unless @connect.login
			res_total = nil
			
			if(file.class.name == "Array")
				filenames = file
				many = true
				res_total = []
			else
				filenames = [file]
				many = false
				
            end
			
			filenames.each do |filename|
				
				log "Uploading #{filename} ..."  
				#Asking for upload parameters and server
				post = connect.post('/al_photos.php',{"__query" => "album#{user.id}_#{id}", "al" => "-1", "al_id" => user.id})
				hash = post.scan(/hash[^\da-z]+([\da-z]+)/)[0][0]
				rhash = post.scan(/rhash[^\da-z]+([\da-z]+)/)[0][0]
				addr = post.scan(/flashLiteUrl\s*\=\s*([^\;]+)/)[0][0].gsub("\"",'').gsub("'",'').gsub("\\",'')
				
				params = {"oid" => user.id, "aid" => id, "gid" => "0", "mid" => user.id, "hash" => hash, "rhash" => rhash, "act" => "do_add", "ajx" => "1"}
				f = File.new(filename, "rb")
				params["photo"] = f
				
				#Uploading photo
				res = connect.post(addr,params)
				f.close
				
				
				#Asking for photo parameters
				hash = res.scan(/hash\=([^\&]+)/)[0][0]
				photos = res.scan(/photos\=([^\&]+)/)[0][0]
				server = res.scan(/server\=([^\&]+)/)[0][0]
				
				
				params = {"photos" => photos,"server" => server,"from" => "html5","context" => "1", "al" => "1", "aid" => id, "gid" => "0", "mid" => user.id, "hash" => hash, "act" => "done_add"}
				res = connect.post('/al_photos.php',params)
				hash = res.scan(/deletePhoto[^\,]+\,\s*([^\)]+)/)[0][0].gsub("\"",'').gsub("'",'')
				res_internal = Image.new.set(self,res.split("<!>").last.split("_").last,res.scan(/x_src\:\s*([^\,]+)/)[0][0].gsub("\"","").gsub("'",""),hash,connect)
				if many
					res_total.push(res_internal)
				else
					res_total = res_internal
				end
			end
			res_total
		end
		
		
		def photos
			return false unless @connect.login
			log "List of photos ..."
			
			res = []
			num = 0
			b = false
			while(true)
				post = @connect.post('/al_photos.php',{"al" => "1","direction" => "1","offset"=>num.to_s, "act" => "show", "list" => "album#{user.id}_#{@id}"})
				json = JSON.parse(post.split("<!json>").last.split("<!>").first)
				num += json.length
				break if json.length == 0
				json.inject(res) do |array,el| 
					id = el['id'].split("_").last
					if(array.find{|p|p.id == id})
						b = true
						break
					end
					array.push(Image.new.set(self,id,el['x_src'],el['hash'],connect))
					array
				end
				break if b
			end
			res
		end
		
		
		def remove
			return false unless @connect.login
			return unless delete_hash
			log "Removing album..."
			@connect.post('/al_photos.php',{"act" => "delete_album", "al" => "1", "album" => "#{user.id}_#{id}", "hash" => delete_hash})
		end
		
	end
	
	class Image
		attr_accessor :id, :album, :connect, :link, :hash_vk 
		def set(album,id,link,hash_vk,connect)
			@id = id
			@album = album
			@connect = connect
			@link = link
			@hash_vk = hash_vk
			self
		end
		
		
		def Image.parse(href)
			id_complex = href.split("/photo").last
			id_complex_split = id_complex.split("_")
			connect = forсe_login(nil,nil)
			resp = connect.post('/al_photos.php', {"act" => "show","al" => "1","photo" => id_complex})
			json = JSON.parse(resp.split("<!>").find{|x| x.index('"id"')}.gsub("<!json>",""))[0]
			Image.new.set(Album.parse("/" + resp.split("<!>").find{|x| x.index("album")}),id_complex_split.last,json["x_src"],json["hash"],connect)
		end
		
		def hash_vk_for_user(connector)
			resp = connector.connect.post('/al_photos.php', {"act" => "show","al" => "1","photo" => "#{album.user.id}_#{id}"})
			JSON.parse(resp.split("<!>").find{|x| x.index('"id"')}.gsub("<!json>",""))[0]["hash"]
		end
	
		def to_s
			"#{@id}"
		end
		
		def uniq_id
			self.id + "_" + self.album.id + "_" + self.album.user.id
		end
		
		def ==(other)
			self.uniq_id == other.uniq_id
		end
		
		def hash
			self.id.hash
		end
		 
		def eql?(other)
			self == other
		end
		
		def download
			return false unless @connect.login
			@connect.save(@link,"images","#{id}_#{@album.name}.jpg")
		end
		
		
		def remove
			return false unless @connect.login
			log "Deleting photo ..."
			@connect.post("/al_photos.php",{"act" => "delete_photo", "al" => "1", "hash" => hash_vk, "photo" => "#{album.user.id}_#{id}"})
		end
		
		
		def mark(users)
			return false unless @connect.login
			if(users.class.name == "Array")
				users_array = users
			else
				users_array = [users]
            end
			
			users_array.each do |user_it|
				log "Marking ..."
				@connect.post('/al_photos.php', {"act" => "add_tag", "al" => "1", "hash" => hash_vk, "mid" => user_it.id, "photo" => "#{album.user.id}_#{id}", "x2" => "1.00000000000000", "x" => "0.00000000000000","y2" => "1.00000000000000", "y" => "0.00000000000000"})
			end
		end
		
		def unmark(users)
			return false unless @connect.login

			resp_tags = @connect.post('/al_photos.php', {"act" => "show","al" => "1","photo" => "#{album.user.id}_#{id}"})
			tagged = JSON.parse(resp_tags.split("<!>").find{|x| x.index('"id"')}.gsub("<!json>",""))[0]["tagged"]
			
			
			if(users.class.name == "Array")
				users_array = users
			else
				users_array = [users]
            end
			users_array.each do |user_it|
				log "Unmarking ..."
				next if tagged.class.name == "Array"
				tag = tagged[user_it.id]
				next unless tag
				@connect.post('/al_photos.php', {"act" => "delete_tag", "al" => "1", "hash" => hash_vk, "tag" => tag, "photo" => "#{album.user.id}_#{id}", "x2" => "1.00000000000000", "x" => "0.00000000000000","y2" => "1.00000000000000", "y" => "0.00000000000000"})
			end
		end
		
		def like(connector=nil)
			connect = forсe_login(connector,@connect)
			if(connector)
				hash_current = hash_vk_for_user(connector)
			else
				hash_current = hash_vk
			end
			
			return false unless connect.login
			return false unless hash_current
			log "Like photo ..."
			res_post = connect.post("/like.php",{"act" => "a_do_like", "al" => "1","from"=>"photo_viewer","hash"=>hash_current,"object"=>"photo#{album.user.id}_#{id}"})
		end
		
		def unlike(connector=nil)
			connect = forсe_login(connector,@connect)
			if(connector)
				hash_current = hash_vk_for_user(connector)
			else
				hash_current = hash_vk
			end
			
			
			return false unless connect.login
			return false unless hash_current
			log "Unlike photo ..."
			res_post = connect.post("/like.php",{"act" => "a_do_unlike", "al" => "1","from"=>"photo_viewer","hash"=>hash_current,"object"=>"photo#{album.user.id}_#{id}"})
		end
		
		
	end


end
