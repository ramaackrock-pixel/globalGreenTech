import React, { useState, useEffect } from 'react';
import { Images, Search, Calendar, User, AlignLeft, X } from 'lucide-react';
import { useSearch } from '../../context/SearchContextProvider';

interface JobPhoto {
  id: string;
  taskId: string;
  staffId: string;
  staffName: string;
  photoUrl: string;
  photoType?: string;
  description: string;
  timestamp: number;
}

const AdminPhotos: React.FC = () => {
  const [photos, setPhotos] = useState<JobPhoto[]>([]);
  const [selectedImage, setSelectedImage] = useState<JobPhoto | null>(null);
  const { searchQuery } = useSearch();

  useEffect(() => {
    const savedPhotos = localStorage.getItem('job_photos');
    if (savedPhotos) {
      setPhotos(JSON.parse(savedPhotos));
    }
  }, []);

  const filteredPhotos = photos.filter((photo) => {
    const matchesSearch = searchQuery.trim() === '' ||
      photo.staffName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      photo.taskId.toLowerCase().includes(searchQuery.toLowerCase()) ||
      photo.description.toLowerCase().includes(searchQuery.toLowerCase());

    return matchesSearch;
  });

  return (
    <div className="space-y-8 pb-20 md:pb-0">

      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 card p-6 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-primary-container/50 to-transparent pointer-events-none"></div>

        <div className="relative z-10">
          <h1 className="text-headline-lg text-on-surface">Job Gallery</h1>
          <p className="text-body-md text-on-surface-variant mt-1">View before/after photos and defect reports uploaded by field staff.</p>
        </div>
      </div>

      {/* Photo Grid */}
      {filteredPhotos.length === 0 ? (
        <div className="card p-12 text-center flex flex-col items-center justify-center">
          <div className="w-16 h-16 bg-surface-container rounded-full flex items-center justify-center mb-4">
            <Images className="w-8 h-8 text-on-surface-variant" />
          </div>
          <h3 className="text-title-lg font-bold text-on-surface">No Photos Found</h3>
          <p className="text-body-md text-on-surface-variant mt-2 max-w-md">There are currently no job photos uploaded by the field staff, or none match your search criteria.</p>
        </div>
      ) : (
        <div className="columns-1 sm:columns-2 lg:columns-3 xl:columns-4 gap-6 space-y-6">
          {filteredPhotos.map((photo) => (
            <div key={photo.id} className="break-inside-avoid card !p-0 overflow-hidden group hover:shadow-lg transition-all duration-300">
              <div className="relative group/img cursor-pointer" onClick={() => setSelectedImage(photo)}>
                <img 
                  src={photo.photoUrl} 
                  alt={photo.description} 
                  className="w-full object-cover aspect-auto max-h-[400px] transition-transform duration-300 group-hover/img:scale-105"
                />
                <div className="absolute inset-0 bg-black/0 group-hover/img:bg-black/10 transition-colors duration-300"></div>
                <div className="absolute top-3 left-3 bg-surface-container-lowest/90 backdrop-blur-sm px-3 py-1.5 rounded-lg shadow-sm border border-outline-variant/20 flex items-center gap-2">
                  <span className="text-label-sm font-bold text-on-surface uppercase tracking-wider">{photo.taskId}</span>
                </div>
                {photo.photoType && (
                  <div className={`absolute top-3 right-3 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider shadow-sm border ${
                    photo.photoType === 'Before Work' ? 'bg-amber-100 text-amber-800 border-amber-200' :
                    photo.photoType === 'After Work' ? 'bg-emerald-100 text-emerald-800 border-emerald-200' :
                    photo.photoType === 'Defect / Damage' ? 'bg-error-container text-on-error-container border-error/20' :
                    'bg-surface-container-highest text-on-surface border-outline-variant/50'
                  }`}>
                    {photo.photoType}
                  </div>
                )}
              </div>
              
              <div className="p-5 space-y-4">
                <div>
                  <div className="flex items-start gap-2 mb-2">
                    <AlignLeft className="w-4 h-4 text-primary shrink-0 mt-0.5" />
                    <p className="text-body-md text-on-surface font-medium leading-relaxed">{photo.description}</p>
                  </div>
                </div>

                <div className="pt-4 border-t border-outline-variant/30 flex justify-between items-center text-label-sm font-bold text-on-surface-variant">
                  <div className="flex items-center gap-1.5">
                    <User className="w-4 h-4" />
                    {photo.staffName}
                  </div>
                  <div className="flex items-center gap-1.5">
                    <Calendar className="w-4 h-4" />
                    {new Date(photo.timestamp).toLocaleDateString(undefined, { month: 'short', day: 'numeric' })}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Lightbox Modal */}
      {selectedImage && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-8">
          <div className="absolute inset-0 bg-slate-900/90 backdrop-blur-sm" onClick={() => setSelectedImage(null)}></div>
          
          <button 
            onClick={() => setSelectedImage(null)}
            className="fixed top-4 right-4 z-[110] text-white/70 hover:text-white bg-black/40 hover:bg-black/60 p-2 rounded-full backdrop-blur-md transition-all"
          >
            <X className="w-8 h-8" />
          </button>

          <div className="relative z-10 max-w-5xl w-full flex flex-col items-center justify-center animate-in fade-in zoom-in-95 duration-300">
            
            <img 
              src={selectedImage.photoUrl} 
              alt={selectedImage.description} 
              className="max-w-full max-h-[80vh] object-contain rounded-lg shadow-2xl"
            />
            
            <div className="w-full max-w-3xl bg-surface-container-lowest/95 backdrop-blur-md p-6 rounded-2xl mt-4 shadow-xl border border-outline-variant/30 flex flex-col md:flex-row gap-6 justify-between items-start md:items-center">
              <div>
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-label-md font-extrabold text-primary bg-primary-container/30 px-3 py-1 rounded-md tracking-wider uppercase">{selectedImage.taskId}</span>
                  {selectedImage.photoType && (
                    <span className="text-[11px] font-bold text-on-surface-variant uppercase tracking-widest">{selectedImage.photoType}</span>
                  )}
                </div>
                <p className="text-body-lg text-on-surface font-medium">{selectedImage.description}</p>
              </div>
              <div className="flex flex-row md:flex-col gap-4 md:gap-1 shrink-0 text-label-sm font-bold text-on-surface-variant text-left md:text-right">
                <div className="flex items-center gap-1.5 justify-end">
                  <User className="w-4 h-4" />
                  {selectedImage.staffName}
                </div>
                <div className="flex items-center gap-1.5 justify-end">
                  <Calendar className="w-4 h-4" />
                  {new Date(selectedImage.timestamp).toLocaleDateString(undefined, { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};

export default AdminPhotos;
