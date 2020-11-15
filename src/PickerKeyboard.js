import React from 'react';
import { Dimensions, Platform, processColor, StyleSheet, View } from 'react-native';
import PickerKeyboardNativeComponent from 'react-native-picker-keyboard/src/PickerKeyboardComponent';
import PropTypes from 'prop-types';

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
    selectedIndexes: $ReadOnlyArray<number | string>,
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

  _onPrev = (event) => {
    this.props.onPrev();
  }

  _onNext = (event) => {
    this.props.onNext();
  }

  render() {
    return (
      <View style={this.props.style}>
        <PickerKeyboardNativeComponent
          ref={(picker) => {
            this._picker = picker;
          }}
          style={[(Platform.OS == 'ios') ? styles.pickerKeyboard : styles.pickerKeyboardAndroid, this.props.itemStyle]}
          textAlign={this.props.textAlign}
          datePicker={this.props.datePicker}
          dateMode={this.props.dateMode}
          dateStyle={this.props.dateStyle}
          componentCount={this.props.componentCount}
          placeholder={this.state.placeholder}
          seperator={this.props.seperator}
          selectedValue={this.props.selectedValue}
          items={this.state.items}
          onChange={this._onChange}
          onPrev={this.props.onPrev}
          onNext={this.props.onNext}
          showClearButton={this.props.showClearButton}
          inputAccessoryViewShow={this.props.inputAccessoryViewShow}
          inputAccessoryViewID={this.props.inputAccessoryViewID}
        />
      </View>
    );
  }
}

PickerKeyboardComponent.propTypes = {
  items: PropTypes.array.isRequired,
}

const styles = StyleSheet.create({
  pickerKeyboard: {
    height: 40,
  },
  pickerKeyboardAndroid: {
    height: 50,
  },
});

export default PickerKeyboardComponent;
