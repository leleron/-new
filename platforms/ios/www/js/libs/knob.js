var creatKnob = function (knobname) {

    var colors = [
        '26e000', '2fe300', '37e700', '45ea00', '51ef00',
        '61f800', '6bfb00', '77ff02', '80ff05', '8cff09',
        '93ff0b', '9eff09', 'a9ff07', 'c2ff03', 'd7ff07',
        'f2ff0a', 'fff30a', 'ffdc09', 'ffce0a', 'ffc30a',
        'ffb509', 'ffa808', 'ff9908', 'ff8607', 'ff7005',
        'ff5f04', 'ff4f03', 'f83a00', 'ee2b00', 'e52000'
    ];

    var rad2deg = 180 / Math.PI;
    var deg = 0;
    var bars = $('#bars');
    var options = '';
    var optionNum = $(knobname).children('.colorBar').length;
    for (var i = 0; i < optionNum; i++) {

        deg = i * 360 / optionNum;

        options = knobname + ' .colorBar:nth-child(' + (i + 1) + ')';
        // 创建选项

        $(options).css({
            //backgroundColor: '#' + colors[i],
            //'transform': 'rotate(' + (deg - 90) + 'deg)',
            'top': -Math.sin(deg / rad2deg) * 140 + 115,
            'left': Math.cos((180 - deg) / rad2deg) * 140 + 110
        });
    }

    var colorBars = bars.find(knobname+' .colorBar');
    var numBars = 0, lastNum = -1;

    $(knobname).knobKnob({
        snap: 0,
        value: 0,
        turn: function (ratio) {
            numBars = Math.round(colorBars.length * ratio);

            // Update the dom only when the number of active bars
            // changes, instead of on every move

            if (numBars == lastNum) {
                return false;
            }
            lastNum = numBars;
            colorBars.removeClass('active').slice(numBars, numBars+1).addClass('active');


        }
    });

};
