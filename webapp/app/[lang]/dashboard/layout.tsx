export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen flex-col md:flex-row md:overflow-hidden">
      <header className="p-4">header</header>
      <nav className="w-full flex-none md:w-64 fixed left-0 px-4 py-16">
        sidebar
      </nav>
      <main className="flex-grow p-6 md:overflow-y-auto md:p-12">
        {children}
      </main>
    </div>
  );
}
