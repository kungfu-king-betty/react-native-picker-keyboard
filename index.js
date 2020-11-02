// @flow

import { requireNativeComponent } from 'react-native';

import type { SyntheticEvent } from 'react-native/Libraries/Types/CoreEventTypes';
import type { TextStyleProp } from 'react-native/Libraries/StyleSheet/StyleSheet';
import type { NativeComponent } from 'react-native/Libraries/Renderer/shims/ReactNative';

type PickerKeyboardChangeEvent = SyntheticEvent<
  $ReadOnly<{|
    value: number | string,
    selectedIndex: number,
  |}>,
>;

type RNPickerKeyboardItemType = $ReadOnly<{|
  label: ?(number | string),
  value: ?(number | string),
|}>;

type RNPickerKeyboardType = Class<
  NativeComponent<
    $ReadOnly<{|
      items: $ReadOnlyArray<RNPickerKeyboardItemType>,
      onChange: (event: PickerKeyboardChangeEvent) => void,
    |}>,
  >,
>;

// requireNativeComponent automatically resolves 'RNPickerKeyboard' to 'RNPickerKeyboardManager'
module.exports = ((requireNativeComponent('RNPickerKeyboard'): any): RNPickerKeyboardType);
