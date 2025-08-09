import React from 'react'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import '@testing-library/jest-dom'
import App from './App'

test('renders title and system time label', () => {
  render(<App />)
  expect(screen.getByText('railsとreactのtddの題材のサンプルアプリ Frontend')).toBeInTheDocument()
  expect(screen.getByText(/System time:/i)).toBeInTheDocument()
})

test('health check button triggers fetch and shows result or error placeholder', async () => {
  // Mock fetch
  const mockResponse = { status: 'ok', commit: 'abc123' }
  const originalFetch = global.fetch
  global.fetch = vi.fn(async () => ({ ok: true, json: async () => mockResponse }))

  render(<App />)
  const button = screen.getByRole('button', { name: /check api health/i })
  await userEvent.click(button)

  const pre = await screen.findByLabelText('api-health-json')
  expect(pre).toHaveTextContent('"status": "ok"')
  expect(pre).toHaveTextContent('"commit": "abc123"')

  // restore
  global.fetch = originalFetch
})


