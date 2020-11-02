import React from 'react';
import { Dimensions, processColor, StyleSheet, View } from 'react-native';
import PickerKeyboardNativeComponent from 'react-native-picker-keyboard/src/PickerKeyboardComponent';

import type { SyntheticEvent } from 'react-native/Libraries/Types/CoreEventTypes';
import type { ColorValue } from 'react-native/Libraries/StyleSheet/StyleSheetTypes';
import type { ViewProps } from 'react-native/Libraries/Components/View/ViewPropTypes';
import type { TextStyleProp } from 'react-native/Libraries/StyleSheet/StyleSheet';
import type { Element, ElementRef, ChildrenArray } from 'react';
import type { NativeComponent } from 'react-native/Libraries/Renderer/shims/ReactNative';


type PickerKeyboardChangeEventItem = $ReadOnly<{|
    selectedIndex: number,
    selectedComponent: number,
    label: number | string,
    value: number | string,
|}>;

type PickerKeyboardChangeEvent = SyntheticEvent<
  $ReadOnly<{|
    selectedIndexes: $ReadOnlyArray<number>,
    selectedComponents: $ReadOnlyArray<PickerKeyboardChangeEventItem>,
  |}>,
>;

type RNPickerKeyboardItemType = $ReadOnly<{|
  label: ?(number | string),
  value: ?(number | string),
|}>;
  
type State = {|
    items: $ReadOnlyArray<RNPickerKeyboardItemType>,
    itemsExtra: $ReadOnlyArray<RNPickerKeyboardItemType>,
    placeholder: string,
|};
  
type ItemProps = $ReadOnly<{|
    label: ?(number | string),
    value?: ?(number | string),
|}>;

const PickerKeyboardItem = (props: ItemProps) => {
    return null;
};

type Props = $ReadOnly<{|
    ...ViewProps,
    itemStyle?: ?TextStyleProp,
    onChange?: ?(event: PickerKeyboardChangeEvent) => mixed,
    placeholder?: ?string
|}>;

type RNPickerKeyboardType = Class<
  NativeComponent<
    $ReadOnly<{|
      items: $ReadOnlyArray<RNPickerKeyboardItemType>,
      onChange: (event: PickerKeyboardChangeEvent) => void,
      style?: ?TextStyleProp,
      placeholder?: ?string
    |}>,
  >,
>;

class PickerKeyboardComponent extends React.Component<Props, State> {
  _picker: ?ElementRef<RNPickerKeyboardType> = null;

  state = {
    items: [],
    itemsExtra: [],
    placeholder: '',
    textAlign: 'left',
  };

  static Item = PickerKeyboardItem;

  static getDerivedStateFromProps(props: Props): State {
    const items = [];
    const itemsExtra = props.itemsExtra;

    if (props.items) {
        props.items.forEach(function (child, index) {
            items.push({
                value: child.value,
                label: child.label,
            });
        });
    }

    const placeholder = props.placeholder;

    return {items, itemsExtra, placeholder};
  }

  _onChange = (event) => {
    this.props.onChange({
        selectedIndexes: event.nativeEvent.selectedIndexes,
        selectedComponents: event.nativeEvent.selectedComponents,
    });
  };

  render() {
    return (
      <View style={this.props.style}>
        <PickerKeyboardNativeComponent
          ref={(picker) => {
            this._picker = picker;
          }}
          style={[styles.pickerKeyboard, this.props.itemStyle]}
          textAlign={this.props.textAlign}
          componentCount={this.props.componentCount}
          placeholder={this.state.placeholder}
          seperator={this.props.seperator}
          selectedIndex={this.props.selectedIndex}
          items={this.state.items}
          onChange={this._onChange}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  pickerKeyboard: {
    height: 40,
  },
});

export default PickerKeyboardComponent;
