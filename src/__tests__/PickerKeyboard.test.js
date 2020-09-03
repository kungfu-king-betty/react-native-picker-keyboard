import React from 'react';
import {Platform} from 'react-native';
import PickerKeyboard from '../PickerKeyboard';

describe('PickerKeyboard', () => {
  it('should render the iOS native component', () => {
    Platform.OS = 'ios';
    expect(<PickerKeyboard />).toMatchSnapshot();
  });
  it('should render the Android native component', () => {});
});
