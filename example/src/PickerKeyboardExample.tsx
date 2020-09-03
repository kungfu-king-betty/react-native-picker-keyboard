import * as React from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { PickerKeyboard } from '../../src';

const Item = PickerKeyboard.Item as any;

function BasicPickerKeyboardExample() {
  const [value, setValue] = React.useState('key1');
  return (
    <PickerKeyboard
      testID="basic-picker-keyboard"
      selectedValue={value}
      onValueChange={(v) => setValue(v)}>
      <Item label="hello" value="key0" />
      <Item label="world" value="key1" />
    </PickerKeyboard>
  );
}

function DisabledPickerKeyboardExample() {
  const [value] = React.useState('key1');

  return (
    <PickerKeyboard enabled={false} selectedValue={value}>
      <Item label="hello" value="key0" />
      <Item label="world" value="key1" />
    </PickerKeyboard>
  );
}

function DropdownPickerKeyboardExample() {
  const [value, setValue] = React.useState('key1');

  return (
    <PickerKeyboard
      selectedValue={value}
      onValueChange={(v) => setValue(v)}
      mode="dropdown">
      <Item label="hello" value="key0" />
      <Item label="world" value="key1" />
    </PickerKeyboard>
  );
}

function PromptPickerKeyboardExample() {
  const [value, setValue] = React.useState('key1');
  return (
    <PickerKeyboard
      selectedValue={value}
      onValueChange={(v) => setValue(v)}
      prompt="Pick one, just one">
      <Item label="hello" value="key0" />
      <Item label="world" value="key1" />
    </PickerKeyboard>
  );
}

function NoListenerPickerKeyboardExample() {
  return (
    <View>
      <PickerKeyboard>
        <Item label="hello" value="key0" />
        <Item label="world" value="key1" />
      </PickerKeyboard>
      <Text>
        Cannot change the value of this picker because it doesn't update
        selectedValue.
      </Text>
    </View>
  );
}

function ColorPickerKeyboardExample() {
  const [value, setValue] = React.useState('red');

  return (
    <>
      <PickerKeyboard
        style={styles.container}
        selectedValue={value}
        onValueChange={(v) => setValue(v)}
        mode="dropdown">
        <Item label="red" color="red" value="red" />
        <Item label="green" color="green" value="green" />
        <Item label="blue" color="blue" value="blue" />
      </PickerKeyboard>
      <PickerKeyboard
        style={{color: value}}
        selectedValue={value}
        onValueChange={(v) => setValue(v)}
        mode="dialog">
        <Item label="red" color="red" value="red" />
        <Item label="green" color="green" value="green" />
        <Item label="blue" color="blue" value="blue" />
      </PickerKeyboard>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    color: 'white',
    backgroundColor: '#333',
  },
});

export const title = '<PickerKeyboard>';
export const description =
  'Provides multiple options to choose from, using either a dropdown menu or a dialog.';
export const examples = [
  {
    title: 'Basic Picker Keyboard',
    render: BasicPickerKeyboardExample,
  },
  {
    title: 'Disabled Picker Keyboard',
    render: DisabledPickerKeyboardExample,
  },
  {
    title: 'Dropdown Picker Keyboard',
    render: DropdownPickerKeyboardExample,
  },
  {
    title: 'Picker Keyboard with prompt message',
    render: PromptPickerKeyboardExample,
  },
  {
    title: 'Picker Keyboard with no listener',
    render: NoListenerPickerKeyboardExample,
  },
  {
    title: 'Colorful picker keyboards',
    render: ColorPickerKeyboardExample,
  },
];
