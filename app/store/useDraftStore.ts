import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { DraftMessage } from './types';

interface DraftStore {
  drafts: DraftMessage[];
  currentDraft: string;
  addDraft: (content: string) => void;
  updateDraft: (id: string, content: string) => void;
  deleteDraft: (id: string) => void;
  setCurrentDraft: (content: string) => void;
  clearCurrentDraft: () => void;
  getDraft: (id: string) => DraftMessage | undefined;
}

export const useDraftStore = create<DraftStore>()(
  persist(
    (set, get) => ({
      drafts: [],
      currentDraft: '',

      addDraft: (content: string) => {
        const newDraft: DraftMessage = {
          id: crypto.randomUUID(),
          content,
          createdAt: new Date(),
          updatedAt: new Date(),
        };
        set((state) => ({
          drafts: [...state.drafts, newDraft],
        }));
      },

      updateDraft: (id: string, content: string) => {
        set((state) => ({
          drafts: state.drafts.map((draft) =>
            draft.id === id
              ? { ...draft, content, updatedAt: new Date() }
              : draft
          ),
        }));
      },

      deleteDraft: (id: string) => {
        set((state) => ({
          drafts: state.drafts.filter((draft) => draft.id !== id),
        }));
      },

      setCurrentDraft: (content: string) => {
        set({ currentDraft: content });
      },

      clearCurrentDraft: () => {
        set({ currentDraft: '' });
      },

      getDraft: (id: string) => {
        return get().drafts.find((draft) => draft.id === id);
      },
    }),
    {
      name: 'draft-storage',
    }
  )
);