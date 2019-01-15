import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/dialog.dart' as Dialog;
import 'package:flutter/material.dart';

/// Picker selected callback.
typedef PickerSelectedCallback = void Function(
    Picker picker, int index, List<int> selecteds);
/// Picker confirm callback.
typedef PickerConfirmCallback = void Function(
    Picker picker, List<int> selecteds);
/// Picker value format callback.
typedef PickerValueFormat<T> = String Function(T value);

/// localizations
class PickerLocalizations {
  static const Map<String, Map<String, Object>> localizedValues = {
    'en': {
      'cancelText': 'Cancel',
      'confirmText': 'Confirm',
      'ampm': ['AM', 'PM'],
    },
    'zh': {
      'cancelText': '取消',
      'confirmText': '确定',
      'ampm': ['上午', '下午'],
    },
  };

  static PickerLocalizations _static = const PickerLocalizations(null);

  final Locale locale;

  const PickerLocalizations(this.locale);

  static PickerLocalizations of(BuildContext context) {
    return Localizations.of<PickerLocalizations>(context, PickerLocalizations) ?? _static;
  }

  Object getItem(String key) {
    Map localData;
    if (locale != null)  localData = localizedValues[locale.languageCode];
    if (localData == null) return localizedValues['en'][key];
    return localData[key];
  }

  String get cancelText => getItem("cancelText");
  String get confirmText => getItem("confirmText");
  List get ampm => getItem("ampm");
}


/// Picker
class Picker {
  static const double DefaultTextSize = 20.0;

  List<int> selecteds;
  final PickerAdapter adapter;
  final List<PickerDelimiter> delimiter;

  final VoidCallback onCancel;
  final PickerSelectedCallback onSelect;
  final PickerConfirmCallback onConfirm;

  final changeToFirst;

  final List<int> columnFlex;

  final Widget title;
  final String cancelText;
  final String confirmText;

  final double height, itemExtent;
  final TextStyle textStyle, cancelTextStyle, confirmTextStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry columnPadding;
  final Color backgroundColor, headercolor, containerColor;
  final bool hideHeader;
  final bool looping;

  Widget _widget;
  PickerWidgetState _state;

  Picker(
      {this.adapter,
      this.delimiter,
      this.selecteds,
      this.height = 150.0,
      this.itemExtent = 28.0,
      this.columnPadding,
      this.textStyle,
      this.cancelTextStyle,
      this.confirmTextStyle,
      this.textAlign = TextAlign.start,
      this.title,
      this.cancelText,
      this.confirmText,
      this.backgroundColor = Colors.white,
      this.containerColor,
      this.headercolor,
      this.changeToFirst = false,
      this.hideHeader = false,
      this.looping = false,
      this.columnFlex,
      this.onCancel,
      this.onSelect,
      this.onConfirm})
      : assert(adapter != null);

  Widget get widget => _widget;
  PickerWidgetState get state => _state;
  int _maxLevel = 1;

  /// 生成picker控件
  Widget makePicker([ThemeData themeData]) {
    _maxLevel = adapter.maxLevel;
    adapter.picker = this;
    adapter.initSelects();
    _widget = new _PickerWidget(picker: this, themeData: themeData);
    return _widget;
  }

  /// 显示 picker
  void show(ScaffoldState state, [ThemeData themeData]) {
    state.showBottomSheet((BuildContext context) {
      return makePicker(themeData);
    });
  }

  /// 显示模态 picker
  void showModal(BuildContext context, [ThemeData themeData]) {
    showModalBottomSheet(
        context: context, //state.context,
        builder: (BuildContext context) {
          return makePicker(themeData);
        });
  }

  /// show dialog picker
  void showDialog(BuildContext context) {
    List<Widget> actions = [];
    String _cancelText =
        cancelText ?? PickerLocalizations.of(context).cancelText;
    String _confirmText =
        confirmText ?? PickerLocalizations.of(context).confirmText;

    if (_cancelText != null && _cancelText != "") {
      actions.add(new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (onCancel != null) onCancel();
          },
          child: new Text(_cancelText)));
    }
    if (_confirmText != null && _confirmText != "") {
      actions.add(new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm(this, selecteds);
          },
          child: new Text(_confirmText)));
    }

    Dialog.showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: title,
            actions: actions,
            content: makePicker(),
          );
        });
  }

  /// 获取当前选择的值
  List getSelectedValues() {
    return adapter.getSelectedValues();
  }
}

/// 分隔符
class PickerDelimiter {
  final Widget child;
  final int column;
  PickerDelimiter({this.child, this.column = 1}) : assert(child != null);
}

/// picker data list item
class PickerItem<T> {
  /// 显示内容
  final Widget text;

  /// 数据值
  final T value;

  /// 子项
  final List<PickerItem<T>> children;

  PickerItem({this.text, this.value, this.children});
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker picker;
  final ThemeData themeData;
  _PickerWidget({Key key, @required this.picker, @required this.themeData})
      : super(key: key);

  @override
  PickerWidgetState createState() =>
      new PickerWidgetState<T>(picker: this.picker, themeData: this.themeData);
}

class PickerWidgetState<T> extends State<_PickerWidget> {
  final Picker picker;
  final ThemeData themeData;
  PickerWidgetState({Key key, @required this.picker, @required this.themeData});

  ThemeData theme;
  final List<FixedExtentScrollController> scrollController = [];

  @override
  void initState() {
    super.initState();
    theme = themeData;
    picker._state = this;
    picker.adapter.doShow();

    if (scrollController.length == 0) {
      for (int i = 0; i < picker._maxLevel; i++)
        scrollController.add(
            new FixedExtentScrollController(initialItem: picker.selecteds[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (picker.hideHeader)
            ? SizedBox()
            : Container(
                child: Row(
                  children: _buildHeaderViews(),
                ),
                decoration: BoxDecoration(
                  border: new Border(
                      top: BorderSide(color: theme.dividerColor, width: 0.5)),
                  color: picker.headercolor == null
                      ? theme.bottomAppBarColor
                      : picker.headercolor,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildViews(),
        ),
      ],
    );
  }

  List<Widget> _buildHeaderViews() {
    if (theme == null) theme = Theme.of(context);
    List<Widget> items = [];
    String _cancelText =
        picker.cancelText ?? PickerLocalizations.of(context).cancelText;
    String _confirmText =
        picker.confirmText ?? PickerLocalizations.of(context).confirmText;

    if (_cancelText != null || _cancelText != "") {
      items.add(new FlatButton(
          onPressed: () {
            if (picker.onCancel != null) picker.onCancel();
            Navigator.of(context).pop();
            picker._widget = null;
          },
          child: new Text(_cancelText,
              overflow: TextOverflow.ellipsis,
              style: picker.cancelTextStyle ??
                  new TextStyle(
                      color: theme.accentColor,
                      fontSize: Picker.DefaultTextSize))));
    }
    items.add(new Expanded(
        child: new Container(
      alignment: Alignment.center,
      child: picker.title == null
          ? picker.title
          : new DefaultTextStyle(
              style: TextStyle(
                  fontSize: Picker.DefaultTextSize,
                  color: theme.textTheme.title.color),
              child: picker.title),
    )));
    if (_confirmText != null || _confirmText != "") {
      items.add(new FlatButton(
          onPressed: () {
            if (picker.onConfirm != null)
              picker.onConfirm(picker, picker.selecteds);
            Navigator.of(context).pop();
            picker._widget = null;
          },
          child: new Text(_confirmText,
              overflow: TextOverflow.ellipsis,
              style: picker.confirmTextStyle ??
                  new TextStyle(
                      color: theme.accentColor,
                      fontSize: Picker.DefaultTextSize))));
    }
    return items;
  }

  bool _changeing = false;
  final Map<int, int> lastData = new Map<int, int>();

  List<Widget> _buildViews() {
    print("_buildViews");
    if (theme == null) theme = Theme.of(context);

    List<Widget> items = [];

    PickerAdapter adapter = picker.adapter;
    if (adapter != null) adapter.setColumn(-1);

    if (adapter != null && adapter.length > 0) {
      for (int i = 0; i < picker._maxLevel; i++) {
        final int _length = adapter.length;

        Widget view = new Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            padding: picker.columnPadding,
            height: picker.height,
            decoration: BoxDecoration(
              border: picker.hideHeader
                  ? null
                  : new Border(
                      top: BorderSide(color: theme.dividerColor, width: 0.5)),
              color: picker.containerColor == null
                  ? theme.dialogBackgroundColor
                  : picker.containerColor,
            ),
            child: CupertinoPicker(
              backgroundColor: picker.backgroundColor,
              scrollController: scrollController[i],
              itemExtent: picker.itemExtent,
              looping: picker.looping,
              onSelectedItemChanged: (int index) {
                print("onSelectedItemChanged");
                setState(() {
                  picker.selecteds[i] = index;
                  updateScrollController(i);
                  adapter.doSelect(i, index);
                  if (picker.changeToFirst) {
                    for (int j = i + 1; j < picker.selecteds.length; j++) {
                      picker.selecteds[j] = 0;
                      scrollController[j].jumpTo(0.0);
                    }
                  }
                  if (picker.onSelect != null)
                    picker.onSelect(picker, i, picker.selecteds);
                });
              },
              children: List<Widget>.generate(_length, (int index) {
                return adapter.buildItem(context, index);
              }),
            ),
          ),
        );
        items.add(view);
        adapter.setColumn(i);
      }
    }
    if (picker.delimiter != null) {
      for (int i = 0; i < picker.delimiter.length; i++) {
        var o = picker.delimiter[i];
        if (o.child == null) continue;
        var item = Container(child: o.child, height: picker.height);
        if (o.column < 0)
          items.insert(0, item);
        else if (o.column >= items.length)
          items.add(item);
        else
          items.insert(o.column, item);
      }
    }
    return items;
  }

  void updateScrollController(int i) {
    if (_changeing || !picker.adapter.isLinkage) return;
    _changeing = true;
    for (int j = 0; j < picker.selecteds.length; j++) {
      if (j != i) {
        if (scrollController[j].position.maxScrollExtent == null)
          continue;
        scrollController[j].position.notifyListeners();
      }
    }
    _changeing = false;
  }
}

/// 选择器数据适配器
abstract class PickerAdapter<T> {
  Picker picker;

  int getLength();
  int getMaxLevel();
  void setColumn(int index);
  void initSelects();
  Widget buildItem(BuildContext context, int index);

  Widget makeText(Widget child, String text) {
    return new Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker.textAlign,
            style: picker.textStyle ??
                new TextStyle(
                    color: Colors.black87, fontSize: Picker.DefaultTextSize),
            child: child ?? new Text(text)
        )
    );
  }

  Widget makeTextEx(Widget child, String text, Widget postfix, Widget suffix) {
    List<Widget> items = [];
    if (postfix != null)
      items.add(postfix);
    items.add(child ?? new Text(text));
    if (suffix != null)
      items.add(suffix);
    return new Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: picker.textAlign,
            style: picker.textStyle ??
                new TextStyle(
                    color: Colors.black87, fontSize: Picker.DefaultTextSize),
            child: Wrap(
              children: items,
            )
        )
    );
  }

  String getText() {
    return getSelectedValues().toString();
  }

  List<T> getSelectedValues() {
    return [];
  }

  void doShow() {}
  void doSelect(int column, int index) {}

  int getColumnFlex(int column) {
    if (picker.columnFlex != null && column < picker.columnFlex.length)
      return picker.columnFlex[column];
    return 1;
  }

  int get maxLevel => getMaxLevel();
  int get length => getLength();
  String get text => getText();

  // 是否联动，即后面的列受前面列数据影响
  bool get isLinkage => getIsLinkage();

  @override
  String toString() {
    return getText();
  }

  bool getIsLinkage() {
    return true;
  }

  /// 通知适配器数据改变
  void notifyDataChanged() {
    if (picker != null && picker.state != null) {
      picker.adapter.doShow();
      picker.adapter.initSelects();
      for (int j = 0; j < picker.selecteds.length; j++)
        picker.state.scrollController[j].jumpToItem(picker.selecteds[j]);
    }
  }
}

/// 数据适配器
class PickerDataAdapter<T> extends PickerAdapter<T> {
  List<PickerItem<T>> data;
  List<PickerItem<dynamic>> _datas;
  int _maxLevel = -1;
  final bool isArray;

  PickerDataAdapter({List pickerdata, this.data, this.isArray = false}) {
    _parseData(pickerdata);
  }

  @override
  bool getIsLinkage() {
    return !isArray;
  }

  void _parseData(final List pickerData) {
    if (pickerData != null &&
        pickerData.length > 0 &&
        (data == null || data.length == 0)) {
      if (data == null) data = new List<PickerItem<T>>();
      if (isArray) {
        _parseArrayPickerDataItem(pickerData, data);
      } else {
        _parsePickerDataItem(pickerData, data);
      }
    }
  }

  _parseArrayPickerDataItem(List pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    for (int i = 0; i < pickerData.length; i++) {
      var v = pickerData[i];
      if (!(v is List)) continue;
      List lv = v;
      if (lv.length == 0) continue;

      PickerItem item = new PickerItem<T>(children: List<PickerItem<T>>());
      data.add(item);

      for (int j = 0; j < lv.length; j++) {
        var o = lv[j];
        if (o is T) {
          item.children.add(new PickerItem<T>(value: o));
        } else if (T == String) {
          String _v = o.toString();
          item.children.add(new PickerItem<T>(value: _v as T));
        }
      }
    }
    print("data.length: ${data.length}");
  }

  _parsePickerDataItem(List pickerData, List<PickerItem> data) {
    if (pickerData == null) return;
    for (int i = 0; i < pickerData.length; i++) {
      var item = pickerData[i];
      if (item is T) {
        data.add(new PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.length == 0) continue;

        List<T> _mapList = map.keys.toList();
        for (int j = 0; j < _mapList.length; j++) {
          var _o = map[_mapList[j]];
          if (_o is List && _o.length > 0) {
            List<PickerItem> _children = new List<PickerItem<T>>();
            //print('add: ${data.runtimeType.toString()}');
            data.add(new PickerItem<T>(value: _mapList[j], children: _children));
            _parsePickerDataItem(_o, _children);
          }
        }
      } else if (T == String && !(item is List)) {
        String _v = item.toString();
        //print('add: $_v');
        data.add(new PickerItem<T>(value: _v as T));
      }
    }
  }

  void setColumn(int index) {
    if (isArray) {
      print("index: $index");
      if (index + 1 < data.length)
        _datas = data[index + 1].children;
      else
        _datas = null;
      return;
    }
    if (index < 0)
      _datas = data;
    else {
      int select = picker.selecteds[index];
      if (_datas != null && _datas.length > select)
        _datas = _datas[select].children;
      else
        _datas = null;
    }
  }

  @override
  int getLength() {
    return _datas == null ? 0 : _datas.length;
  }

  @override
  getMaxLevel() {
    if (_maxLevel == -1) _checkPickerDataLevel(data, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final PickerItem item = _datas[index];
    if (item.text != null) {
      return item.text;
    }
    return makeText(item.text, item.text != null ? null : item.value.toString());
  }

  @override
  void initSelects() {
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = new List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selecteds.add(0);
    }
  }

  @override
  List<T> getSelectedValues() {
    List<T> _items = [];
    if (picker.selecteds != null) {
      if (isArray) {
        for (int i = 0; i < picker.selecteds.length; i++) {
          int j = picker.selecteds[i];
          if (j < 0 || data[i].children == null || j >= data[i].children.length)
            break;
          _items.add(data[i].children[j].value);
        }
      } else {
        List<PickerItem<dynamic>> datas = data;
        for (int i = 0; i < picker.selecteds.length; i++) {
          int j = picker.selecteds[i];
          if (j < 0 || j >= datas.length) break;
          _items.add(datas[j].value);
          datas = datas[j].children;
          if (datas == null || datas.length == 0) break;
        }
      }
    }
    return _items;
  }

  _checkPickerDataLevel(List<PickerItem> data, int level) {
    if (data == null) return;
    if (isArray) {
      _maxLevel = data.length;
      return;
    }
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children.length > 0)
        _checkPickerDataLevel(data[i].children, level + 1);
    }
    if (_maxLevel < level) _maxLevel = level;
  }
}

class NumberPickerColumn {
  final List<int> items;
  final int begin;
  final int end;
  final int initValue;
  final int columnFlex;
  final Widget postfix, suffix;
  final PickerValueFormat<int> onFormatValue;

  NumberPickerColumn({
      this.begin = 0,
      this.end = 9,
      this.items,
      this.initValue,
      this.columnFlex = 1,
      this.postfix,
      this.suffix,
      this.onFormatValue,
   });

  int indexOf(int value) {
    if (value == null) return -1;
    if (items != null) return items.indexOf(value);
    if (value < begin || value > end) return -1;
    return value - begin;
  }

  int valueOf(int index) {
    if (items != null) {
      return items[index];
    }
    return begin + index;
  }

  String getValueText(int index) {
    return onFormatValue == null ? "${valueOf(index)}" : onFormatValue(valueOf(index));
  }
}

class NumberPickerAdapter extends PickerAdapter<int> {
  NumberPickerAdapter({this.data}) : assert(data != null);

  final List<NumberPickerColumn> data;
  NumberPickerColumn cur;

  @override
  int getLength() {
    if (cur == null) return 0;
    if (cur.items != null) return cur.items.length;
    int v = cur.end - cur.begin + 1;
    if (v < 1) return 0;
    return v;
  }

  @override
  int getMaxLevel() {
    return data == null ? 0 : data.length;
  }

  @override
  bool getIsLinkage() {
    return false;
  }

  @override
  void setColumn(int index) {
    if (index + 1 >= data.length)
      cur = null;
    else
      cur = data[index + 1];
  }

  @override
  void initSelects() {
    int _maxLevel = getMaxLevel();
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = new List<int>();
      for (int i = 0; i < _maxLevel; i++) {
        int v = data[i].indexOf(data[i].initValue);
        if (v < 0) v = 0;
        picker.selecteds.add(v);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    if (cur.postfix == null && cur.suffix == null)
      return makeText(null, cur.getValueText(index));
    else
      return makeTextEx(null, cur.getValueText(index), cur.postfix, cur.suffix);
  }

  @override
  int getColumnFlex(int column) {
    return data[column].columnFlex;
  }

  @override
  List<int> getSelectedValues() {
    List<int> _items = [];
    if (picker.selecteds != null) {
      for (int i = 0; i < picker.selecteds.length; i++) {
        int j = picker.selecteds[i];
        int v = data[i].valueOf(j);
        _items.add(v);
      }
    }
    return _items;
  }
}

/// Picker DateTime Adapter Type
class PickerDateTimeType {
  static const int kMDY = 0; // m, d, y
  static const int kHM = 1; // hh, mm
  static const int kHMS = 2; // hh, mm, ss
  static const int kHM_AP = 3; // hh, mm, ap(AM/PM)
  static const int kMDYHM = 4; // m, d, y, hh, mm
  static const int kMDYHM_AP = 5; // m, d, y, hh, mm, AM/PM
  static const int kMDYHMS = 6; // m, d, y, hh, mm, ss

  static const int kYMD = 7; // y, m, d
  static const int kYMDHM = 8; // y, m, d, hh, mm
  static const int kYMDHMS = 9; // y, m, d, hh, mm, ss
  static const int kYMD_AP_HM = 10; // y, m, d, ap, hh, mm

  static const int kYM = 11; // y, m
  static const int kDMY = 12; // d, m, y
}

class DateTimePickerAdapter extends PickerAdapter<DateTime> {
  final int type;
  final bool isNumberMonth;
  final List<String> months;
  final List<String> strAMPM;
  final int yearBegin, yearEnd;
  final String yearSuffix, monthSuffix, daySuffix;
  /// year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  final List<int> customColumnType;

  static const List<String> MonthsList_EN = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> MonthsList_EN_L = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  DateTimePickerAdapter({
    Picker picker,
    this.type = 0,
    this.isNumberMonth = false,
    this.months = MonthsList_EN,
    this.strAMPM,
    this.yearBegin = 1900,
    this.yearEnd = 2100,
    this.value,
    this.yearSuffix,
    this.monthSuffix,
    this.daySuffix,
    this.customColumnType,
  }) {
    super.picker = picker;
  }

  int _col = 0;
  int _colAP = -1;

  DateTime value;

  // but it can improve the performance, so keep it.
  static const List<List<int>> lengths = const [
    [12, 31, 0],
    [24, 60],
    [24, 60, 60],
    [12, 60, 2],
    [12, 31, 0, 24, 60],
    [12, 31, 0, 12, 60, 2],
    [12, 31, 0, 24, 60, 60],
    [0, 12, 31],
    [0, 12, 31, 24, 60],
    [0, 12, 31, 24, 60, 60],
    [0, 12, 31, 2, 12, 60],
    [0, 12],
    [31, 12, 0],
  ];

  static const Map<int, int> columnTypeLength = {
    0: 0,
    1: 12,
    2: 31,
    3: 24,
    4: 60,
    5: 60,
    6: 2,
    7: 12
  };

  /// year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  static const List<List<int>> columnType = const [
    [1, 2, 0],
    [3, 4],
    [3, 4, 5],
    [7, 4, 6],
    [1, 2, 0, 3, 4],
    [1, 2, 0, 7, 4, 6],
    [1, 2, 0, 3, 4, 5],
    [0, 1, 2],
    [0, 1, 2, 3, 4],
    [0, 1, 2, 3, 4, 5],
    [0, 1, 2, 6, 7, 4],
    [0, 1],
    [2, 1, 0],
  ];

  static const List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

  // 获取当前列的类型
  int getColumnType(int index) {
    if (customColumnType != null)
      return customColumnType[index];
    List<int> items = columnType[type];
    if (index >= items.length) return -1;
    return items[index];
  }

  @override
  int getLength() {
    int v = customColumnType == null ? lengths[type][_col] : columnTypeLength[customColumnType[_col]];
    if (v == 0) return yearEnd - yearBegin;
    if (v == 31) return _calcDateCount(value.year, value.month);
    return v;
  }

  @override
  int getMaxLevel() {
    return customColumnType == null ? lengths[type].length : customColumnType.length;
  }

  @override
  void setColumn(int index) {
    //print("setColumn index: $index");
    _col = index + 1;
    if (_col < 0) _col = 0;
  }

  @override
  void initSelects() {
    if (value == null) value = DateTime.now();
    _colAP = _getAPColIndex();
    int _maxLevel = getMaxLevel();
    if (picker.selecteds == null || picker.selecteds.length == 0) {
      if (picker.selecteds == null) picker.selecteds = new List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selecteds.add(0);
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    String _text = "";
    int colType = getColumnType(_col);
    switch (colType) {
      case 0:
        _text = "${yearBegin + index}${_checkStr(yearSuffix)}";
        break;
      case 1:
        if (isNumberMonth) {
          _text = "${index + 1}${_checkStr(monthSuffix)}";
        } else {
          _text = "${months[index]}";
        }
        break;
      case 2:
        _text = "${index + 1}${_checkStr(daySuffix)}";
        break;
      case 3:
      case 4:
      case 5:
        _text = "${intToStr(index)}";
        break;
      case 6:
        List _ampm = strAMPM ?? PickerLocalizations.of(context).ampm;
        if (_ampm == null) _ampm = const ['AM', 'PM'];
        _text = "${_ampm[index]}";
        break;
      case 7:
        _text = "${intToStr(index+1)}";
        break;
    }

    return makeText(null, _text);
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  int getColumnFlex(int column) {
    if (getColumnType(column) == 0) {
      return 3;
    }
    return 2;
  }

  @override
  void doShow() {
    for (int i = 0; i < getMaxLevel(); i++) {
      int colType = getColumnType(i);
      switch (colType) {
        case 0:
          picker.selecteds[i] = value.year - yearBegin;
          break;
        case 1:
          picker.selecteds[i] = value.month - 1;
          break;
        case 2:
          picker.selecteds[i] = value.day - 1;
          break;
        case 3:
          picker.selecteds[i] = value.hour;
          break;
        case 4:
          picker.selecteds[i] = value.minute;
          break;
        case 5:
          picker.selecteds[i] = value.second;
          break;
        case 6:
          picker.selecteds[i] = (value.hour > 12 || value.hour == 0) ? 1 : 0;
          break;
        case 7:
          picker.selecteds[i] = value.hour == 0 ? 11 :
              (value.hour > 12) ? value.hour - 12 - 1 : value.hour - 1;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int year, month, day, h, m, s;
    year = value.year;
    month = value.month;
    day = value.day;
    h = value.hour;
    m = value.minute;
    s = value.second;
    if (type != 2 && type != 6) s = 0;

    int colType = getColumnType(column);
    switch (colType) {
      case 0:
        year = yearBegin + index;
        break;
      case 1:
        month = index + 1;
        break;
      case 2:
        day = index + 1;
        break;
      case 3:
        h = index;
        break;
      case 4:
        m = index;
        break;
      case 5:
        s = index;
        break;
      case 6:
        if (picker.selecteds[_colAP] == 0) {
          if (h == 0) h = 12;
          if (h > 12) h = h - 12;
        } else {
          if (h < 12) h = h + 12;
          if (h == 12) h = 0;
        }
        break;
      case 7:
        h = index + 1;
        if (_colAP >= 0 && picker.selecteds[_colAP] == 1) h = h + 12;
        if (h > 23) h = 0;
        break;
    }
    int cday = _calcDateCount(year, month);
    if (day > cday) day = cday;
    value = new DateTime(year, month, day, h, m, s);
  }

  int _getAPColIndex() {
    List<int> items = customColumnType ?? columnType[type];
    for (int i = 0; i < items.length; i++) {
      if (items[i] == 6) return i;
    }
    return -1;
  }

  int _calcDateCount(int year, int month) {
    if (leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  String intToStr(int v) {
    if (v < 10) return "0$v";
    return "$v";
  }

  String _checkStr(String v) {
    return v == null ? "" : v;
  }
}
