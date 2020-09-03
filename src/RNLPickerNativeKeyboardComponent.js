'use strict';

import {requireNativeComponent} from 'react-native';

import type {SyntheticEvent} from 'react-native/Libraries/Types/CoreEventTypes';
import type {TextStyleProp} from 'react-native/Libraries/StyleSheet/StyleSheet';
import type {NativeComponent} from 'react-native/Libraries/Renderer/shims/ReactNative';

type PickerKeyboardIOSChangeEvent = SyntheticEvent<
  $ReadOnly<{|
    newValue: number | string,
    newIndex: number,
  |}>,
>;

type RNLPickerKeyboardIOSTypeItemType = $ReadOnly<{|
  label: ?Label,
  value: ?(number | string),
  textColor: ?number,
|}>;

type Label = Stringish | number;

type RNLPickerKeyboardIOSType = Class<
  NativeComponent<
    $ReadOnly<{|
      items: $ReadOnlyArray<RNLPickerKeyboardIOSTypeItemType>,
      onChange: (event: PickerKeyboardIOSChangeEvent) => void,
      selectedIndex: number,
      style?: ?TextStyleProp,
      testID?: ?string,
    |}>,
  >,
>;

module.exports = ((requireNativeComponent(
  'RNLPickerKeyboard',
): any): RNLPickerKeyboardIOSType);
