import * as React from 'react';
import { Platform, ScrollView, StyleSheet, Text, View } from 'react-native';

import * as PickerKeyboardExamples from './PickerKeyboardExample';
import * as PickerKeyboardIOSExamples from './PickerKeyboardIOSExample';

export default function App() {
  return (
    <ScrollView style={styles.container}>
      <Text style={styles.heading}>Picker Examples</Text>
      {PickerKeyboardExamples.examples.map((element) => (
        <View style={styles.elementContainer} key={element.title}>
          <Text style={styles.title}> {element.title} </Text>
          {element.render()}
        </View>
      ))}
      {Platform.OS === 'ios' && (
        <Text style={styles.heading}>PickerIOS Examples</Text>
      )}
      {Platform.OS === 'ios' &&
        PickerKeyboardIOSExamples.examples.map((element) => (
          <View style={styles.elementContainer} key={element.title}>
            <Text style={styles.title}> {element.title} </Text>
            {element.render()}
          </View>
        ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    ...Platform.select({
      ios: {
        paddingTop: 30,
      },
    }),
    backgroundColor: '#F5FCFF',
    margin: 16,
  },
  title: {
    fontSize: 18,
  },
  elementContainer: {
    marginTop: 8,
  },
  heading: {
    fontSize: 22,
    color: 'black',
  },
});
