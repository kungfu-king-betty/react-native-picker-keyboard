/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {Component} from 'react';
import {StyleSheet, Text, TextInput, View, Button} from 'react-native';

import RNPickerKeyboard from 'react-native-picker-keyboard';

export default class App extends Component {

  constructor(props) {
    super(props);
    this.state = {text: ''};
  }
  render() {
    return (
      <View style={styles.container}>
        <Text>Please enter text</Text>
        <TextInput
          style={{margin:10}}
          multiline={true}
          placeholder="Type text to display in toast"
          onChangeText={(text) => this.setState({text})}
        />
        <Button
          onPress={() => {RNPickerKeyboard.show(this.state.text)}}
          title="Show Toast"
          color="#841584"
          accessibilityLabel="Learn more about this purple button"
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
    backgroundColor: '#F5FCFF',
  },
});
