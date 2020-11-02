/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {Component} from 'react';
import {StyleSheet, Text, TextInput, View, Button} from 'react-native';

import PickerKeyboard from 'react-native-picker-keyboard';

export default class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <PickerKeyboard
          style={{ width: '90%' }}
          textAlign={'left'}
          componentCount={2}
          placeholder={'Select a test option...'}
          seperator={' - '}
          items={[{'label':'Select a test option...', 'value':''}, {'label':'Hello', 'value':'hi'}, {'label':'Bye', 'value':'bye'}, {'label':'Select a test option...', 'value':''}, {'label':'Good', 'value':'good'}, {'label':'Bad', 'value':'bad'}]}
          selectedIndex={[0, 1]}
          onChange={(newObj) => {
            console.log(newObj);
          }}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
