import { StatusBar } from 'expo-status-bar';
import React from 'react';
import { SafeAreaView, Text, View, StyleSheet, Pressable } from 'react-native';

export default function App() {
    return (
        <SafeAreaView style={styles.container}>
            <View>
                <Text accessibilityRole="header" style={styles.title}>오늘, 우리 — MVP</Text>
                <Text style={styles.body}>시니어 친화 UI · 큰 터치 영역 · 고대비 시작점</Text>
                <Pressable accessibilityRole="button" style={styles.button}>
                    <Text style={styles.buttonText}>로그인으로 시작</Text>
                </Pressable>
            </View>
            <StatusBar style="auto" />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24, backgroundColor: '#fff' },
    title: { fontSize: 24, fontWeight: '700', marginBottom: 12 },
    body: { fontSize: 16, marginBottom: 24 },
    button: { backgroundColor: '#1f6feb', paddingHorizontal: 32, paddingVertical: 16, borderRadius: 12, minWidth: 200 },
    buttonText: { color: '#fff', textAlign: 'center', fontSize: 18 }
});
