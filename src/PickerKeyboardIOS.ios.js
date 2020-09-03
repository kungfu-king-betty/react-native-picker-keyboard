'use strict';

import React from 'react';
import {processColor, StyleSheet, View} from 'react-native';
import RNLPickerKeyboardNativeComponent from './RNLPickerNativeKeyboardComponent';

import type {SyntheticEvent} from 'react-native/Libraries/Types/CoreEventTypes';
import type {ColorValue} from 'react-native/Libraries/StyleSheet/StyleSheetTypes';
import type {ViewProps} from 'react-native/Libraries/Components/View/ViewPropTypes';
import type {TextStyleProp} from 'react-native/Libraries/StyleSheet/StyleSheet';
import type {Element, ElementRef, ChildrenArray} from 'react';
import type {NativeComponent} from 'react-native/Libraries/Renderer/shims/ReactNative';

type PickerKeyboardIOSChangeEvent = SyntheticEvent<
  $ReadOnly<{|
    newValue: number | string,
    newIndex: number,
  |}>,
>;

type RNLPickerKeyboardIOSItemType = $ReadOnly<{|
  label: ?Label,
  value: ?(number | string),
  textColor: ?number,
|}>;

type RNLPickerKeyboardIOSType = Class<
  NativeComponent<
    $ReadOnly<{|
      items: $ReadOnlyArray<RNLPickerKeyboardIOSItemType>,
      onChange: (event: PickerKeyboardIOSChangeEvent) => void,
      selectedIndex: number,
      style?: ?TextStyleProp,
      testID?: ?string,
    |}>,
  >,
>;

type Label = Stringish | number;

type Props = $ReadOnly<{|
  ...ViewProps,
  children: ChildrenArray<Element<typeof PickerKeyboardIOSItem>>,
  itemStyle?: ?TextStyleProp,
  onChange?: ?(event: PickerKeyboardIOSChangeEvent) => mixed,
  onValueChange?: ?(itemValue: string | number, itemIndex: number) => mixed,
  selectedValue: ?(number | string),
|}>;

type State = {|
  selectedIndex: number,
  items: $ReadOnlyArray<RNLPickerKeyboardIOSItemType>,
|};

type ItemProps = $ReadOnly<{|
  label: ?Label,
  value?: ?(number | string),
  color?: ?ColorValue,
|}>;

const PickerKeyboardIOSItem = (props: ItemProps) => {
  return null;
};

class PickerKeyboardIOS extends React.Component<Props, State> {
  _picker: ?ElementRef<RNLPickerKeyboardIOSType> = null;

  state = {
    selectedIndex: 0,
    items: [],
  };

  static Item = PickerKeyboardIOSItem;

  static getDerivedStateFromProps(props: Props): State {
    let selectedIndex = 0;
    const items = [];
    React.Children.toArray(props.children).forEach(function (child, index) {
      if (child.props.value === props.selectedValue) {
        selectedIndex = index;
      }
      items.push({
        value: child.props.value,
        label: child.props.label,
        textColor: processColor(child.props.color),
      });
    });
    return {selectedIndex, items};
  }

  render() {
    return (
      <View style={this.props.style}>
        <RNLPickerKeyboardNativeComponent
          ref={(picker) => {
            this._picker = picker;
          }}
          testID={this.props.testID}
          style={[styles.pickerKeyboardIOS, this.props.itemStyle]}
          items={this.state.items}
          selectedIndex={this.state.selectedIndex}
          onChange={this._onChange}
        />
      </View>
    );
  }

  _onChange = (event) => {
    if (this.props.onChange) {
      this.props.onChange(event);
    }
    if (this.props.onValueChange) {
      this.props.onValueChange(
        event.nativeEvent.newValue,
        event.nativeEvent.newIndex,
      );
    }

    // The picker is a controlled component. This means we expect the
    // on*Change handlers to be in charge of updating our
    // `selectedValue` prop. That way they can also
    // disallow/undo/mutate the selection of certain values. In other
    // words, the embedder of this component should be the source of
    // truth, not the native component.
    if (
      this._picker &&
      this.state.selectedIndex !== event.nativeEvent.newIndex
    ) {
      this._picker.setNativeProps({
        selectedIndex: this.state.selectedIndex,
      });
    }
  };
}

const styles = StyleSheet.create({
  pickerKeyboardIOS: {
    // The picker will conform to whatever width is given, but we do
    // have to set the component's height explicitly on the
    // surrounding view to ensure it gets rendered.
    height: 216,
  },
});

export default PickerKeyboardIOS;
